;Header and description
(define (domain bar)

    (:requirements 
        :strips 
        :fluents 
        :durative-actions 
        :typing  
        :negative-preconditions  
        :equality 
    )

    (:types 
        waiter
        barista
        location
        drinkHot
        drinkCold
    )

    (:constants 
        onTray -location ;where drinks are
        bar table1 table2 table3 table4 -location ;location tables and bar
        bartender -barista ;the only barista
    )

    (:predicates 
        (isAt ?w -waiter ?loc -location) ;used to identify location of waiter(s)
        (isOnCold ?d -drinkCold ?loc -location) ;used to identify location of cold drink
        (isOnHot ?d -drinkHot ?loc -location) ;used to identify location of hot drink
        (isOn ?x -object ?l -location) ;used for the tray when is onGrabber
        (isDirty ?t -location) ;when the table is to clean
        (cleaning ?w -waiter) ;when the waiter is cleaning, therefore it can't move
        (toPrepareCold ?d -drinkCold ?t -location) ;correlate a cold dink with the table of the order, deactivate after finishing preparation and activate toServe
        (toPrepareHot ?d -drinkHot ?t -location) ;correlate a hot dink with the table of the order, deactivate after finishing preparation and activate toServe
        (toServeCold ?d -drinkCold ?t -location) ;correlate a cold dink with the table where it must be served
        (toServeHot ?d -drinkHot ?t -location) ;correlate a hot dink with the table where it must be served
        (free ?b -object) ;used for waiter(s) and barista or for tables cleaned
        (toServeBiscuit ?t -location) ;biscuit is held by a waiter and must be served at table t
        (serveTable ?w -waiter ?t -location) ;to assign dinamically at every problem, which waiter should serve which table
        (biscuitGrabbed ?grab -location) ;to avoid bug where robot pick tray, load biscuit on it, drops it and then proceeds to serve it as if the biscuit would be onGrabber
        (occupied ?t -location) ;used to alert other waiters that a place is occupied by another waiter
        (assigned ?t -location) ;to prevent assignation to multiple waiters
        (belongs ?grab -location ?w -waiter) ;to differenciate grabbers of two waiters
        (toServe ?t -location) ;table that has to be served
        (consumeCold ?d -drinkCold ?t -location) ;used to trigger process of consuming a drink cold
        (consumeHot ?d -drinkHot ?t -location) ;used to trigger process of consuming a drink hot
        (consumedCold ?d -drinkCold ?t -location) ;used after a drink has been consumed
        (consumedHot ?d -drinkHot ?t -location) ;used after a drink has been consumed
    )


    (:functions
        (waiterSpeed ?w -waiter) ;speed of waiter(s)
        (connection ?t1 -location ?t2 -location) ;distance between tables and bar
        (numPlaceOnTray) ;free space on tray
        (numBiscuit ?t -location) ;number of biscuits
        (numDrink ?t -location) ;total number of drinks
        (numDrinkServed ?t -location) ;number of drinks served
        (numDrinkToConsume ?t -location) ;number of drinks to consume
        (surfaceTable ?t -location) ;surface of table
    )

    ;action for loading the tray with cold drinks
    (:action loadCold
        :parameters (?d -drinkCold ?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (> (numPlaceOnTray) 0)
        )
        :effect (and 
            (not (isOnCold ?d bar))
            (isOnCold ?d onTray)
            (decrease (numPlaceOnTray) 1)
        )
    )
    
    ;action for loading the tray with hot drinks
    (:action loadHot
        :parameters (?d -drinkHot ?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (> (numPlaceOnTray) 0)
        )
        :effect (and 
            (not (isOnHot ?d bar))
            (isOnHot ?d onTray)
            (decrease (numPlaceOnTray) 1)
        )
    )
    
    ;action for loading the tray with biscuit
    (:action loadBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (> (numPlaceOnTray) 0)
            (> (numBiscuit ?t) 0)
        )
        :effect (and 
            (decrease (numPlaceOnTray) 1)
            (toServeBiscuit ?t)
        )
    )
    
    ;action to pick the tray
    (:action pickTray
        :parameters (?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (not (isOn onTray ?grab))
            (free ?w)
        )
        :effect (and 
            (isOn onTray ?grab)
            (not (free ?w))
            (assign (waiterSpeed ?w) 1)
        )
    )
    
    ;action to release the tray
    (:action dropTray
        :parameters (?w -waiter ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
        )
        :effect (and 
            (not (isOn onTray ?grab))
            (free ?w)
            (assign (waiterSpeed ?w) 2)
        )
    )
    
    ;action for grabbing a cold drink
    (:action grabCold
        :parameters (?w -waiter ?d - drinkCold ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnCold ?d bar)
            (belongs ?grab ?w)
            (free ?w)
        )
        :effect (and 
            (not (isOnCold ?d bar))
            (not (free ?w))
            (isOnCold ?d ?grab)
        )
    )

    ;action for grabbing a hot drink
    (:action grabHot
        :parameters (?w -waiter ?d - drinkHot ?grab -location)
        :precondition (and 
            (isAt ?w bar)
            (isOnHot ?d bar)
            (belongs ?grab ?w)
            (free ?w)
        )
        :effect (and 
            (not (isOnHot ?d bar))
            (not (free ?w))
            (isOnHot ?d ?grab)
        )
    )

    ;action for grabing a buscuit
    (:action grabBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and
            (isAt ?w bar)
            (free ?w)
            (belongs ?grab ?w)
            (> (numBiscuit ?t) 0)
            (biscuitGrabbed ?grab)
        )
        :effect (and 
            (not (free ?w))
            (toServeBiscuit ?t)
        )
    )
    
    ;action for serving cold drinks from the tray
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
            (not (isOnCold ?d onTray))
            (isOn onTray ?grab)
            (not (toServeCold ?d ?t))
            (increase (numPlaceOnTray) 1)
            (increase (numBiscuit ?t) 1)
            (increase (numDrinkServed ?t) 1)
            (consumeCold ?d ?t)
        )
    )
    
    ;action for serving hot drinks from the tray
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
            (not (isOnHot ?d onTray))
            (isOn onTray ?grab)
            (not (toServeHot ?d ?t))
            (increase (numPlaceOnTray) 1)
            (increase (numBiscuit ?t) 1)
            (increase (numDrinkServed ?t) 1)
            (consumeHot ?d ?t)
        )
    )

    ;action for serving buiscuit from the tray
    (:action serveBiscuitTray
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (isOn onTray ?grab)
            (toServeBiscuit ?t)
            (> (numBiscuit ?t) 0)
            (serveTable ?w ?t)
        )
        :effect (and 
            (increase (numPlaceOnTray) 1)
            (not (toServeBiscuit ?t))
            (decrease (numBiscuit ?t) 1)
        )
    )
    
    ;action for serving cold drinks from the grabber
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
            (not (isOnCold ?d ?grab))
            (not (toServeCold ?d ?t))
            (increase (numBiscuit ?t) 1)
            (increase (numDrinkServed ?t) 1)
            (consumeCold ?d ?t)
        )
    )
    
    ;action for serving hot drinks from the grabber
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
            (not (isOnHot ?d ?grab))
            (not (toServeHot ?d ?t))
            (increase (numBiscuit ?t) 1)
            (increase (numDrinkServed ?t) 1)
            (consumeHot ?d ?t)
        )
    )

    ;action for serving biscuit from the grabber
    (:action serveBiscuit
        :parameters (?w -waiter ?t -location ?grab -location)
        :precondition (and 
            (isAt ?w ?t)
            (belongs ?grab ?w)
            (toServeBiscuit ?t)
            (> (numBiscuit ?t) 0)
            (not (isOn onTray ?grab))
            (serveTable ?w ?t)
            (biscuitGrabbed ?grab)
        )
        :effect (and 
            (free ?w)
            (not (biscuitGrabbed ?grab))
            (not (toServeBiscuit ?t))
            (decrease (numBiscuit ?t) 1)
        )
    )
    
    ;action for finishing consumation of cold drinks
    (:action finishConsumationCold
        :parameters (?d - drinkCold ?t -location)
        :precondition  
            (consumedCold ?d ?t)
        :effect (and 
            (not (consumedCold ?d ?t))
            (assign (numDrinkToConsume ?t) (- (numDrinkToConsume ?t) 1))
        )
    )

    ;action for finishing consumation of hot drinks
    (:action finishConsumationHot
        :parameters (?d - drinkHot ?t -location)
        :precondition 
            (consumedHot ?d ?t)
        :effect (and 
            (not (consumedHot ?d ?t))
            (assign (numDrinkToConsume ?t) (- (numDrinkToConsume ?t) 1))
        )
    )

    ;action for leaving customers
    (:action customerLeave
        :parameters (?t -location)
        :precondition (and 
            (toServe ?t)
            (>= (- (numDrinkServed ?t) (numDrink ?t)) 0)
            (< (- (numDrinkServed ?t) (numDrink ?t)) 1)
            (< (numDrinkToConsume ?t) 1)
            (< (numBiscuit ?t) 1)
        )
        :effect 
            (isDirty ?t)
    )

    ;action to assign waiter(s) to table
    (:action assignTable
        :parameters (?w -waiter ?t -location)
        :precondition (and 
            (not (serveTable ?w ?t))
            (not (assigned ?t))
        )
        :effect (and 
            (serveTable ?w ?t)
            (assigned ?t)
        )
    )

    ;durative actions for consuming cold drinks
    (:durative-action consumeDrinkCold
        :parameters (?d -drinkCold ?t -location)
        :duration (= ?duration 4)
        :condition 
            (at start (consumeCold ?d ?t))
        :effect (and 
            (at end (not (consumeCold ?d ?t)))
            (at end (consumedCold ?d ?t))
        )
    )
    
    ;durative actions for consuming hot drinks
    (:durative-action consumeDrinkHot
        :parameters (?d -drinkHot ?t -location)
        :duration (= ?duration 4)
        :condition
            (at start (consumeHot ?d ?t))
        :effect (and 
            (at end (not (consumeHot ?d ?t)))
            (at end (consumedHot ?d ?t))
        )
    )

    ;durative action for moving the waiter
    (:durative-action move
        :parameters (?w -waiter ?t1 -location ?t2 -location)
        :duration (= ?duration (/ (connection ?t1 ?t2) (waiterSpeed ?w)))
        :condition (and 
            (at start (isAt ?w ?t1))
            (at start (not (cleaning ?w)))
            (over all (not (occupied ?t2)))
            
        )
        :effect (and 
            (at start (not (isAt ?w ?t1)))
            (at start (not (occupied ?t1)))
            (at end (isAt ?w ?t2))
            (at end (occupied ?t2))
        )
    )

    ;durative action for preparing cold drinks
    (:durative-action prepareCold
        :parameters (?b -barista ?d -drinkCold ?t -location)
        :duration (= ?duration 3)
        :condition (and 
            (at start (free ?b))
            (at start (toPrepareCold ?d ?t))
        )
        :effect (and 
            (at start (not (free ?b)))
            (at end (free ?b))
            (at end (not (toPrepareCold ?d ?t)))
            (at end (toServeCold ?d ?t))
            (at end (isOnCold ?d bar))
        )
    )
    
    ;durative action for preparing hot drinks
    (:durative-action prepareHot
        :parameters (?b -barista ?d -drinkHot ?t -location)
        :duration (= ?duration 5)
        :condition (and 
            (at start (free ?b))
            (at start (toPrepareHot ?d ?t))
        )
        :effect (and 
            (at start (not(free ?b)))
            (at end (free ?b))
            (at end (not (toPrepareHot ?d ?t)))
            (at end (toServeHot ?d ?t))
            (at end (isOnHot ?d bar))
        )
    )

    ;durative actions for cleaning tables
    (:durative-action cleanTable    
        :parameters (?t -location ?w -waiter)
        :duration (= ?duration (* (surfaceTable ?t) 2))
        :condition (and 
            (at start (isAt ?w ?t))
            (at start (isDirty ?t))
            (at start (free ?w))
            (at start (serveTable ?w ?t))
        )
        :effect (and 
            (at start (cleaning ?w))
            (at end (not (isDirty ?t)))
            (at end (not (cleaning ?w)))
            (at end (free ?t))
        )
    )
)

