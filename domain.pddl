;Header and description

(define (domain bar)

;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality :time)

    (:types 
        waiter
        barista
        location
        drinkHot
        drinkCold
    )

    (:constants 
        onTray -location ;where drinks are
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
        (serveTable ?w -waiter ?t -location) ;to assign dinamically at every problem, which waiter should serve which table
        (biscuitGrabbed ?grab -location) ;to avoid bug where robot pick tray, load biscuit on it, drops it and then proceeds to serve it as if the biscuit would be onGrabber
        (occupied ?t -location) ;used to alert other waiters that a place is occupied by another waiter
        (assigned ?t -location) ;to prevent assignation to multiple waiters
        (belongs ?grab -location ?w -waiter)
        (debug) ;put this in some effect to see if it triggers, to use only for debugging
        (isTable ?t -location)
        (toServe ?t -location)
        (consumeCold ?d -drinkCold ?t -location) ;used to trigger process of consuming a drink cold
        (consumeHot ?d -drinkHot ?t -location) ;used to trigger process of consuming a drink hot
        (consumedCold ?d -drinkCold ?t -location) ;used after a drink has been consumed
        (consumedHot ?d -drinkHot ?t -location) ;used after a drink has been consumed
    )


    (:functions
        (waiterSpeed ?w -waiter)
        (connection ?t1 -location ?t2 -location)
        (numPlaceOnTray)
        (numBiscuit ?t -location)
        (numDrink ?t -location)
        (numDrinkServed ?t -location)
        (numDrinkToConsume ?t -location)
    )

    (:action loadCold
        :parameters (?d -drinkCold ?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (>(numPlaceOnTray)0)
        )
        :effect (and 
            (not(isOnCold ?d bar))
            (isOnCold ?d onTray)
            (decrease(numPlaceOnTray)1)
        )
    )
    
    (:action loadHot
        :parameters (?d -drinkHot ?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (>(numPlaceOnTray)0)
        )
        :effect (and 
            (not(isOnHot ?d bar))
            (isOnHot ?d onTray)
            (decrease(numPlaceOnTray)1)
        )
    )
    
    (:action loadBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (>(numPlaceOnTray)0)
            (>(numBiscuit ?t)0)
        )
        :effect (and 
            (decrease(numPlaceOnTray)1)
            (toServeBiscuit ?t)
        )
    )
    
    (:action pickTray
        :parameters (?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (not(isOn onTray ?grab))
            (free ?w)
        )
        :effect (and 
            (isOn onTray ?grab)
            (not(free ?w))
            (assign(waiterSpeed ?w)1)
        )
    )
    
    (:action dropTray
        :parameters (?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
        )
        :effect (and 
            (not(isOn onTray ?grab))
            (free ?w)
            (assign (waiterSpeed ?w)2)
        )
    )
    
    (:action grabCold
        :parameters (?w -waiter ?d - drinkCold ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (belongs ?grab ?w)
            (free ?w)
        )
        :effect (and 
            (not(isOnCold ?d bar))
            (not(free ?w))
            (isOnCold ?d ?grab)
        )
    )

    (:action grabHot
        :parameters (?w -waiter ?d - drinkHot ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (belongs ?grab ?w)
            (free ?w)
        )
        :effect (and 
            (not(isOnHot ?d bar))
            (not(free ?w))
            (isOnHot ?d ?grab)
        )
    )

    (:action grabBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and
            (isAt ?w bar)
            (free ?w)
            (belongs ?grab ?w)
            (>(numBiscuit ?t)0)
            (biscuitGrabbed ?grab)
        )
        :effect (and 
            (not(free ?w))
            (toServeBiscuit ?t)
        )
    )
    

    (:action serveColdTray
        :parameters (?w -waiter ?d -drinkCold ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (isOnCold ?d onTray)
            (isOn onTray ?grab)
            (toServeCold ?d ?t)
            (serveTable ?w ?t)
        )
        :effect (and 
            (not(isOnCold ?d onTray))
            (isOn onTray ?grab)
            (not(toServeCold ?d ?t))
            (increase(numPlaceOnTray)1)
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
            (consumeCold ?d ?t)
        )
    )
    
    (:action serveHotTray
        :parameters (?w -waiter ?d -drinkHot ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (isOnHot ?d onTray)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (toServeHot ?d ?t)
            (serveTable ?w ?t)
        )
        :effect (and 
            (not(isOnHot ?d onTray))
            (isOn onTray ?grab)
            (not(toServeHot ?d ?t))
            (increase(numPlaceOnTray)1)
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
            (consumeHot ?d ?t)
        )
    )

    (:action serveBiscuitTray
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (toServeBiscuit ?t)
            (>(numBiscuit ?t)0)
            (serveTable ?w ?t)
        )
        :effect (and 
            (increase(numPlaceOnTray)1)
            (not(toServeBiscuit ?t))
            (decrease(numBiscuit ?t)1)
        )
    )
    

    (:action serveCold
        :parameters (?w -waiter ?d - drinkCold ?t - location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (isOnCold ?d ?grab)
            (toServeCold ?d ?t)
            (serveTable ?w ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnCold ?d ?grab))
            (not(toServeCold ?d ?t))
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
            (consumeCold ?d ?t)
        )
    )
    
    (:action serveHot
        :parameters (?w -waiter ?d - drinkHot ?t - location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (isOnHot ?d ?grab)
            (toServeHot ?d ?t)
            (serveTable ?w ?t)
        )
        :effect (and 
            (free ?w)
            (not(isOnHot ?d ?grab))
            (not(toServeHot ?d ?t))
            (increase(numBiscuit ?t)1)
            (increase(numDrinkServed ?t)1)
            (consumeHot ?d ?t)
        )
    )

    (:action serveBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (toServeBiscuit ?t)
            (>(numBiscuit ?t)0)
            (not (isOn onTray ?grab))
            (serveTable ?w ?t)
            (biscuitGrabbed ?grab)
        )
        :effect (and 
            (free ?w)
            (not(biscuitGrabbed ?grab))
            (not(toServeBiscuit ?t))
            (decrease(numBiscuit ?t)1)
        )
    )
    
    (:action finishConsumationCold
        :parameters (?d - drinkCold ?t -location)
        :precondition (and 
            (consumedCold ?d ?t)
        )
        :effect (and 
            (not(consumedCold ?d ?t))
            (decrease(numDrinkToConsume ?t)1)
        )
    )
    

    (:action customerLeave
        :parameters (?t -location)
        :precondition (and 
            (toServe ?t)
            (>=(-(numDrinkServed ?t)(numDrink ?t))0)
            (<(-(numDrinkServed ?t)(numDrink ?t))1)
            ;(<(numDrinkToConsume ?t)1)
            (<(numBiscuit ?t)1)
        )
        :effect (and 
            (isDirty ?t)
        )
    )

    ; IGNORE THIS ACTION FOR NOW
    (:action stop
        :parameters (?t -location)
        :precondition (and 
            (<(numDrinkToConsume ?t)1)
        )
        :effect (and 
            (isDirty ?t)
        )
    )
    

    (:action assignTable
        :parameters (?w -waiter ?t -location)
        :precondition (and 
            (not (serveTable ?w ?t))
            (not(assigned ?t))
        )
        :effect (and 
            (serveTable ?w ?t)
            (assigned ?t)
        )
    )

    ; IGNORE THIS ACTION FOR NOW
    (:durative-action consumeDrinkCold
        :parameters (?d -drinkCold ?t -location)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and 
                (consumeCold ?d ?t)
            ))
        )
        :effect (and 
            (at end (and 
                (not(consumeCold ?d ?t))
            ))
            (at end (and
                (consumedCold ?d ?t)
            ))
        )
    )
    
    ;IGNORE THIS ACTION FOR NOW
    (:durative-action consumeDrinkHot
        :parameters (?d -drinkHot ?t -location)
        :duration (= ?duration 4)
        :condition (and 
            (at start (and 
                (consumeHot ?d ?t)
            ))
        )
        :effect (and 
            (at end (and 
                (not(consumeHot ?d ?t))
            ))
            (at end (and
                (consumedHot ?d ?t)
            ))
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
            (over all 
                (not(occupied ?t2))
            )
        )
        :effect (and 
            (at start
                (not(isAt ?w ?t1))
            )
            (at start
                (not(occupied ?t1))
            )
            (at end
                (isAt ?w ?t2)
            )
            (at end 
                (occupied ?t2)
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
            (at start (and
                (serveTable ?w ?t)
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

;---------------------------------------------------

;RISOLTO PROBLEMA OnTray (usa isTable)

;TODO: METTERE DURATA CORRETTA SU cleanTable
;TODO: CAPIRE PERCHè I NUMERIC FUNZIONANO STRANI

;         ^
;         |
;         |
;Per ora da ignorare

;---------------------------------------------------

;Per il controllo della soluzione:
; - Controllare che i due waiter servano solo i tavoli a cui vengono assegnati (All'inizio ci sarà (ASSIGN table w))
; - Controllare che i due robot non si trovino mai nello stesso luogo
