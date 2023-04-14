;Header and description

(define (domain bar)

;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

    (:types 
        waiter
        barista
        location
        drinkHot
        drinkCold
        biscuit
    )

    (:constants 
        onGrabber onTray -location ;where drinks are
        bar table1 table2 table3 table4 -location ;location tables+bar
        bartender -barista ;there's only one barista in every problem
    )

    (:predicates 
        (isAt ?w -waiter ?loc -location)
        (isOnCold ?d -drinkCold ?loc -location)
        (isOnHot ?d -drinkHot ?loc -location)
        (isOn ?x -object ?l -location)
        (isDirty ?t -location)
        (cleaning ?w -waiter)
        (toPrepareCold ?d -drinkCold ?t -location)
        (toPrepareHot ?d -drinkHot ?t -location)
        (toServeCold ?d -drinkCold ?t -location)
        (toServeHot ?d -drinkHot ?t -location)
        (toServeBiscuit ?b -biscuit ?t -location)
        (free ?b -object)
    )


    (:functions
        (waiterSpeed ?w -waiter)
        (connection ?t1 -location ?t2 -location)
        (numPlaceOnTray)
    )

    (:action loadCold
        :parameters (?d -drinkCold ?w -waiter)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (isOn onTray onGrabber)
            (>(numPlaceOnTray)0)
        )
        :effect (and 
            (not(isOnCold ?d bar))
            (isOnCold ?d onTray)
            (decrease(numPlaceOnTray)1)
        )
    )
    
    (:action loadHot
        :parameters (?d -drinkHot ?w -waiter)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (isOn onTray onGrabber)
            (>(numPlaceOnTray)0)
        )
        :effect (and 
            (not(isOnHot ?d bar))
            (isOnHot ?d onTray)
            (decrease(numPlaceOnTray)1)
        )
    )
    
    (:action loadBiscuit
        :parameters (?w -waiter ?b -biscuit)
        :precondition (and 
            (isAt ?w bar)
            (isOn onTray onGrabber)
            (>(numPlaceOnTray)0)
        )
        :effect (and 
            (isOn ?b onTray)
            (decrease(numPlaceOnTray)1)
        )
    )
    
    
    (:action pickTray
        :parameters (?w -waiter)
        :precondition (and 
            (isAt ?w bar)
            (not(isOn onTray onGrabber))
            (free ?w)
        )
        :effect (and 
            (isOn onTray onGrabber)
            (not(free ?w))
            (assign(waiterSpeed ?w)1)
        )
    )
    
    (:action dropTray
        :parameters (?w -waiter)
        :precondition (and 
            (isAt ?w bar)
            (isOn onTray onGrabber)
        )
        :effect (and 
            (not(isOn onTray onGrabber))
            (free ?w)
            (assign (waiterSpeed ?w)2)
        )
    )
    
    (:action grabCold
        :parameters (?w -waiter ?d - drinkCold)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (free ?w)
        )
        :effect (and 
            (not(isOnCold ?d bar))
            (not(free ?w))
            (isOnCold ?d onGrabber)
        )
    )

    (:action grabHot
        :parameters (?w -waiter ?d - drinkHot)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (free ?w)
        )
        :effect (and 
            (not(isOnHot ?d bar))
            (not(free ?w))
            (isOnHot ?d onGrabber)
        )
    )

    (:action grabBiscuit
        :parameters (?w -waiter ?b -biscuit)
        :precondition (and
            (isAt ?w bar)
            (free ?w)
        )
        :effect (and 
            (not(free ?w))
            (isOn ?b onGrabber)
        )
    )
    

    (:action serveColdTray
        :parameters (?w -waiter ?d -drinkCold ?t -location ?b -biscuit)
        :precondition (and 
            (isAt ?w ?t)
            (isOnCold ?d onTray)
            (toServeCold ?d ?t)
        )
        :effect (and 
            (not(isOnCold ?d onTray))
            (not(toServeCold ?d ?t))
            (increase(numPlaceOnTray)1)
            (toServeBiscuit ?b ?t)
        )
    )
    
    (:action serveHotTray
        :parameters (?w -waiter ?d -drinkHot ?t -location ?b -biscuit)
        :precondition (and 
            (isAt ?w ?t)
            (isOnHot ?d onTray)
            (toServeHot ?d ?t)
        )
        :effect (and 
            (not(isOnHot ?d onTray))
            (not(toServeHot ?d ?t))
            (increase(numPlaceOnTray)1)
            (toServeBiscuit ?b ?t)
        )
    )

    (:action serveBiscuitTray
        :parameters (?w -waiter ?b -biscuit ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOn ?b onTray)
            (toServeBiscuit ?b ?t)
        )
        :effect (and 
            (not(isOn ?b onTray))
            (increase(numPlaceOnTray)1)
            (not(toServeBiscuit ?b ?t))
        )
    )
    

    (:action serveCold
        :parameters (?w -waiter ?d - drinkCold ?t - location ?b -biscuit)
        :precondition (and 
            (isAt ?w ?t)
            (isOnCold ?d onGrabber)
            (toServeCold ?d ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnCold ?d onGrabber))
            (not(toServeCold ?d ?t))
            (toServeBiscuit ?b ?t)
        )
    )
    
    (:action serveHot
        :parameters (?w -waiter ?d - drinkHot ?t - location ?b -biscuit)
        :precondition (and 
            (isAt ?w ?t)
            (isOnHot ?d onGrabber)
            (toServeHot ?d ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnHot ?d onGrabber))
            (not(toServeHot ?d ?t))
            (toServeBiscuit ?b ?t)
        )
    )

    (:action serveBiscuit
        :parameters (?w -waiter ?b -biscuit ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOn ?b onGrabber)
            (toServeBiscuit ?b ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOn ?b onGrabber))
            (not(toServeBiscuit ?b ?t))
        )
    )

    (:durative-action move
        :parameters (?w -waiter ?t1 -location ?t2 -location ?d -drinkCold)
        :duration (= ?duration (/(connection ?t1 ?t2)(waiterSpeed ?w)))
        :condition (and 
            (at start 
                (isAt ?w ?t1)
            )
            (at start 
                (not(cleaning ?w))
            )
        )
        :effect (and 
            (at start
                (not(isAt ?w ?t1))
            )
            (at end
                (isAt ?w ?t2)
            )
        )
    )

    (:durative-action prepareCold
        :parameters (?b -barista ?d -drinkCold ?t -location)
        :duration (= ?duration 3)
        :condition (and 
            (at start (and 
                (free ?b)
            ))
            (at start (and 
                (toPrepareCold ?d ?t)
            ))
        )
        :effect (and 
            (at start (and 
                (not(free ?b))
            ))
            (at end (and 
                (free ?b)
            ))
            (at end (and 
                (not(toPrepareCold ?d ?t))
            ))
            (at end (and 
                (toServeCold ?d ?t)
            ))
            (at end (and 
                (isOnCold ?d bar)
            ))
        )
    )
    
    (:durative-action prepareHot
        :parameters (?b -barista ?d -drinkHot ?t -location)
        :duration (= ?duration 5)
        :condition (and 
            (at start (and 
                (free ?b)
            ))
            (at start (and 
                (toPrepareHot ?d ?t)
            ))
        )
        :effect (and 
            (at start (and 
                (not(free ?b))
            ))
            (at end (and 
                (free ?b)
            ))
            (at end (and 
                (not(toPrepareHot ?d ?t))
            ))
            (at end (and 
                (toServeHot ?d ?t)
            ))
            (at end (and 
                (isOnHot ?d bar)
            ))
        )
    )
    

    (:durative-action cleanTable
        :parameters (?t -location ?w -waiter)
        :duration (= ?duration 2)
        :condition (and 
            (at start (and 
                (isAt ?w ?t)
            ))
            (at start (and 
                (isDirty ?t)
            ))
        )
        :effect (and 
            (at start (and 
                (cleaning ?w)
            ))
            (at end (and 
                (not(isDirty ?t))
            ))
            (at end (and 
                (not(cleaning ?w))
            ))
        )
    )
)

;TODO: RISOLVERE PROBLEMA OnTray
;TODO: METTERE DURATA CORRETTA SU cleanTable
