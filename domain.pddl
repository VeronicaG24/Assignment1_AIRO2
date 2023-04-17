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
    )

    (:constants 
        onGrabber onTray -location ;where drinks are
        bar table1 table2 table3 table4 -location ;location tables+bar
        bartender -barista ;there's only one barista in every problem
    )

    (:predicates 
        (isAt ?w -waiter ?loc -location) ;used to identify location of waiter(s)
        (isOnCold ?d -drinkCold ?loc -location) ;used to identify location of dcold drink (onGrabber/onTray)
        (isOnHot ?d -drinkHot ?loc -location) ;same as above, but for hot drinks
        (isOn ?x -object ?l -location) ;used for the tray when is onGrabber
        (isDirty ?t -location) ;when the table is to clean
        (cleaning ?w -waiter) ;when the waiter is cleaning, therefore it can't move
        (toPrepareCold ?d -drinkCold ?t -location) ;correlate a cold dink with the table of the order, deactivate after finishing preparation and activate toServe
        (toPrepareHot ?d -drinkHot ?t -location) ;same as above, but for hot drinks
        (toServeCold ?d -drinkCold ?t -location) ;correlate a cold dink with the table where it must be served
        (toServeHot ?d -drinkHot ?t -location) ;same as above, but for hot drinks
        (free ?b -object) ;used for waiter(s) and barista or for tables cleaned
        (toServeBiscuit ?t -location) ;biscuit is held by a waiter and must be served at table t
        (biscuitGrabbed) ;to avoid bug where robot pick tray, load biscuit on it, drops it and then proceeds to serve it as if the biscuit would be onGrabber
        (debug) ;put this in some effect to see if it triggers, to use only for debugging
        (isTable ?t -location)
        (toServe ?t -location)
    )


    (:functions
        (waiterSpeed ?w -waiter)
        (connection ?t1 -location ?t2 -location)
        (numPlaceOnTray)
        (numBiscuit ?t -location)
        (numDrink ?t -location)
        (numDrinkServed ?t -location)
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
        :parameters (?w -waiter ?t -location)
        :precondition (and 
            (isAt ?w bar)
            (isOn onTray onGrabber)
            (>(numPlaceOnTray)0)
            (>(numBiscuit ?t)0)
        )
        :effect (and 
            (decrease(numPlaceOnTray)1)
            (toServeBiscuit ?t)
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
        :parameters (?w -waiter ?t -location)
        :precondition (and
            (isAt ?w bar)
            (free ?w)
            (>(numBiscuit ?t)0)
            (biscuitGrabbed)
        )
        :effect (and 
            (not(free ?w))
            (toServeBiscuit ?t)
        )
    )
    

    (:action serveColdTray
        :parameters (?w -waiter ?d -drinkCold ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOnCold ?d onTray)
            (isOn onTray onGrabber)
            (toServeCold ?d ?t)
        )
        :effect (and 
            (not(isOnCold ?d onTray))
            (isOn onTray onGrabber)
            (not(toServeCold ?d ?t))
            (increase(numPlaceOnTray)1)
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
        )
    )
    
    (:action serveHotTray
        :parameters (?w -waiter ?d -drinkHot ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOnHot ?d onTray)
            (isOn onTray onGrabber)
            (toServeHot ?d ?t)
        )
        :effect (and 
            (not(isOnHot ?d onTray))
            (isOn onTray onGrabber)
            (not(toServeHot ?d ?t))
            (increase(numPlaceOnTray)1)
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
        )
    )

    (:action serveBiscuitTray
        :parameters (?w -waiter ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOn onTray onGrabber)
            (toServeBiscuit ?t)
            (>(numBiscuit ?t)0)
        )
        :effect (and 
            (increase(numPlaceOnTray)1)
            (not(toServeBiscuit ?t))
            (decrease(numBiscuit ?t)1)
        )
    )
    

    (:action serveCold
        :parameters (?w -waiter ?d - drinkCold ?t - location )
        :precondition (and 
            (isAt ?w ?t)
            (isOnCold ?d onGrabber)
            (toServeCold ?d ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnCold ?d onGrabber))
            (not(toServeCold ?d ?t))
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
        )
    )
    
    (:action serveHot
        :parameters (?w -waiter ?d - drinkHot ?t - location )
        :precondition (and 
            (isAt ?w ?t)
            (isOnHot ?d onGrabber)
            (toServeHot ?d ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnHot ?d onGrabber))
            (not(toServeHot ?d ?t))
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
        )
    )

    (:action serveBiscuit
        :parameters (?w -waiter ?t -location)
        :precondition (and 
            (isAt ?w ?t)
            (toServeBiscuit ?t)
            (>(numBiscuit ?t)0)
            (not (isOn onTray Ongrabber))
            (biscuitGrabbed)
        )
        :effect (and 
            (free ?w)
            (not(biscuitGrabbed))
            (not(toServeBiscuit ?t))
            (decrease(numBiscuit ?t)1)
        )
    )
    
    (:action customerLeave
        :parameters (?t -location)
        :precondition (and 
            (toServe ?t)
            (>=(-(numDrinkServed ?t)(numDrink ?t))0)
            (<(-(numDrinkServed ?t)(numDrink ?t))1)
            (<(numBiscuit ?t)1)
        )
        :effect (and 
            (isDirty ?t)
        )
    )
    

    (:durative-action move
        :parameters (?w -waiter ?t1 -location ?t2 -location)
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
            (at start (and
                (free ?w)
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
            (at end (and 
                (free ?t)
            ))
        )
    )
)

;TODO: RISOLVERE PROBLEMA OnTray
;TODO: METTERE DURATA CORRETTA SU cleanTable
;TODO: CAPIRE PERCHè I NUMERIC FUNZIONANO STRANI
