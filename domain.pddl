(define (domain domain_robot)

    ;remove requirements that are not needed
    (:requirements 
        :strips 
        :fluents 
        :numeric-fluents
        :durative-actions 
        :timed-initial-literals 
        :typing 
        :conditional-effects 
        :negative-preconditions 
        :duration-inequalities 
        :equality
        :disjunctive-preconditions
    )

    (:types 
        location
        robot
        drinkHot
        drinkCold
    )

    (:constants 
        onGrabber onTray -location ;where drinks are
        bar table1 table2 table3 table4 -location ;location tables+bar

    )

    (:predicates
        (waiter ?w -robot)
        (barista ?b -robot)
        (tray ?t -object)
        (atTray ?loc -location  ?t -object) ;stands for tray at location
        (atRobot ?loc -location  ?r -robot) ;stands for obot at location
        (atDrinkhot ?loc -location  ?d -drinkhot) ;stands for drinkhot at location
        (atDrinkcold ?loc -location  ?d -drinkcold) ;stands for drinkcold at location
        (free ?d) ;we use it for waiter, barista and tables
        (dirtyTable ?loc-location) ;dirty table
        (cleaning ?w-robot) ;table that is being cleaning
        (tableToServe ?table -location) ;table to serve
        (tableMaking ?table -location) ;table for which the barista is making the drinks
        (tableServed ?table -location) ;table for which the drinks are served
        (tableMaked ?table -location) ;table for which the drinks are made and served
        (tableServing ?table -location) ;table for which the drinks are served
    )


    (:functions
        (connection ?l1-location ?l2-location);this is the distance between bar and tables
        (waiterSpeed ?r-robot) ;this is the speed of waiter
        (numPlaceOnTray ) ;free places on tray
        (toMakeCold ?table -location) ;number of cold drink per table to make
        (toMakeHot ?table -location)  ;number of hot drink per table to make
        (toServeCold ?table -location) ;number of cold drink per table to serve
        (toServeHot ?table -location)  ;number of hot drink per table to serve
        (servedCold ?table -location) ;number of cold drink per table served
        (servedHot ?table -location)  ;number of hot drink per table served
        (surfaceTable ?loc -location) ;stands for the surface of table
        (numdrink ?table -location) ;to end service
    )



    (:action pickDrinkHot
        :parameters (?d -drinkHot ?w -robot ?table -location ?tr -object) 
        :precondition (and
            (waiter ?w)
            (atDrinkhot bar ?d)
            (tray ?tr)
            (atRobot bar ?w)
            (free ?tr)
            (=(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (not (atDrinkhot bar ?d))
            (atDrinkhot onGrabber ?d)
            (assign(waiterSpeed ?w)2)
            (not(free ?tr))
            (decrease(toServeHot ?table)1)
        )
    )

    (:action pickDrinkCold
        :parameters (?d -drinkCold ?w -robot ?table -location ?tr -object)
        :precondition (and
            (waiter ?w)
            (atDrinkcold bar ?d)
            (tray ?tr)
            (atRobot bar ?w)
            (free ?tr)
            (=(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (not (atDrinkcold bar ?d))
            (atDrinkcold onGrabber ?d)
            (assign(waiterSpeed ?w)2)
             (not(free ?tr))
            (decrease(toServeCold ?table)1)
        )
    )

    (:action loadTrayHot
        :parameters (?d -drinkHot ?w -robot ?tray -object ?table -location)
        :precondition (and
            (waiter ?w)
            (atDrinkhot bar ?d)
            (>=(numPlaceOnTray)1)
            (atRobot bar ?w)
            (free ?w)
            (tray ?tray)
            (atTray bar ?tray)
            (>(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (decrease(toServeHot ?table)1)
            (atDrinkhot onTray ?d)
            (decrease (numPlaceOnTray)1)
        )  
    )

    (:action loadTrayCold
        :parameters (?d -drinkCold ?w -robot ?tray -object ?table -location)
        :precondition (and
            (waiter ?w)
            (atDrinkcold bar ?d)
            (>=(numPlaceOnTray)1)
            (atDrinkcold bar ?d)
            (free ?w)
            (tray ?tray)
            (atTray bar ?tray)
            (>(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (decrease(toServeCold ?table)1)
            (atDrinkcold onTray ?d)
            (decrease (numPlaceOnTray)1)
        ) 
    )

    (:action pickTray
        :parameters (?w -robot ?tray -object  ?table -location)
        :precondition (and
            (waiter ?w)
            (atRobot bar ?w)
            (tray ?tray)
            (atTray bar ?tray)
            (or (=(numPlaceOnTray)0) (and (<(numPlaceOnTray)2)(=(+(toServeHot ?table)(toServeCold ?table))1)))
        )
        :effect (and
            (assign(waiterSpeed ?w)1)
            (not (free ?tray))
        )
    )

    (:action serveDrinkHot
        :parameters (?d -drinkHot ?w -robot ?table -location)
        :precondition (and
            (waiter ?w)
            (atRobot ?table ?w)
            (atDrinkhot onGrabber ?d)
            (not (free ?w))
        )
        :effect (and
            (not (atDrinkhot onGrabber ?d))
            (atDrinkhot ?table ?d)
            (decrease(toServeHot ?table)1)
            (increase(servedHot ?table)1)
        )
    )

   (:action serveDrinkCold
        :parameters (?d -drinkCold ?w -robot ?table -location)
        :precondition (and
            (waiter ?w)
            (atRobot ?table ?w)
            (atDrinkcold onGrabber ?d)
            (not (free ?w))
        )
        :effect (and
            (not (atDrinkcold onGrabber ?d))
            (atDrinkcold ?table ?d)
            (decrease(toServeCold ?table)1)
            (increase(servedCold ?table)1)
        )
    )

    (:action serveTrayHot
        :parameters (?d -drinkHot ?w -robot ?table -location)
        :precondition (and
            (waiter ?w)
            (atRobot ?table ?w)
            (atDrinkhot onTray ?d)
            (not (free ?w))
        )
        :effect (and
            (not (atDrinkhot onTray ?d))
            (atDrinkhot ?table ?d)
            (decrease(toServeHot ?table)1)
            (increase(servedHot ?table)1)
            (increase (numPlaceOnTray)1)
        )
    )

    (:action serveTrayCold
        :parameters (?d -drinkCold ?w -robot ?table -location)
        :precondition (and
            (waiter ?w)
            (atRobot ?table ?w)
            (atDrinkcold onTray ?d)
            (not (free ?w))
        )
        :effect (and
            (not (atDrinkcold onTray ?d))
            (atDrinkcold ?table ?d)
            (decrease(toServeCold ?table)1)
            (increase(servedCold ?table)1)
            (increase (numPlaceOnTray)1)
        )
    )

    (:action releaseTray
        :parameters (?w -robot ?table - location ?tray -object)
        :precondition (and
            (waiter ?w)
            (atRobot bar ?w)
            (tray ?tray)
            (=(numPlaceOnTray)3)
            (not (free ?w))
        )
        :effect (and
            (free ?w)
            (free ?tray)
        )
    )

    (:action startService
        :parameters (?table -location ?w -robot)
        :precondition (and 
            (waiter ?w)
            (not(tableToServe ?table))
            (free ?table)
            (free ?w)
            (not(tableServed ?table))
            (tableServing ?table)
        )
        :effect  (and
            (tableToServe ?table)
            (not(free ?w))
        )
    )

    (:action endService
        :parameters (?table - location ?w -robot)
        :precondition (and 
            (waiter ?w)
            (tableToServe ?table)
            (=(+(toServeHot ?table)(toServeCold ?table))0)
            (=(-(numdrink ?table) (+(servedCold ?table)(servedHot ?table)))0)
        )
        :effect (and
            (not(tableToServe ?table))
            (tableServed ?table)
            (not(tableServing ?table))
        )
    )


    (:action startMaking
        :parameters (?table - location ?b - robot)
        :precondition (and 
            (barista ?b)
            (not(tableMaking?table))
            (free ?b)
            (not(tableMaked ?table))
        )
        :effect  (and
            (tableMaking ?table)
            (not(free ?b))
            (tableServing ?table)
        )
    )

    (:action endMaking
        :parameters (?table - location ?b - robot)
        :precondition (and 
            (not(free ?b))
            (tableMaking ?table)
            (=(+(toMakeCold ?table)(toMakeHot?table))0)
        )
        :effect (and
            (not(tableMaking ?table))
            (free ?b)
             (tableMaked ?table)
        )
    )
    (:durative-action move
        :parameters (?t1  -location ?t2 -location ?w -robot)
        :duration (= ?duration (/(connection ?t1 ?t2)(waiterSpeed ?w)))
        :condition (and 
            (over all(waiter ?w)) 
            (at start (and (atRobot ?t1 ?w) (not(cleaning ?w))))
        )
        :effect (and 
            (at end (and (not (atRobot ?t1 ?w)) (atRobot ?t2 ?w)))
        )
    )
    
    (:durative-action prepareCold
        :parameters (?b -robot ?d - drinkCold ?table - location)
        :duration (= ?duration 3)
        :condition (and 
            (over all(barista ?b))
            (at start (and (>(toMakeCold ?table)0) (free ?b)))
        )
        :effect (and 
            (at start 
                (and (not (free ?b)))
            )
            (at end 
                (and (atDrinkcold bar ?d) (decrease(toMakeCold ?table)1) (increase(toServeCold ?table)1) (free ?b))
            )
        )
    )

    (:durative-action prepareHot
        :parameters (?b ?w -robot ?d - drinkHot ?table - location)
        :duration (= ?duration 5)
        :condition (and 
            (over all(waiter ?w))
            (over all(barista ?b))
            (at start (and (>(toMakeHot )0) (free ?b)))
        )
        :effect (and 
            (at start (and (not (free ?b))))
            (at end (and (atDrinkhot bar ?d) (decrease(toMakeHot ?table)1) (increase(toServeHot ?table)1) (free ?b)))
        )
    )
    
    (:durative-action cleanTable
        :parameters (?t -location ?w -robot)
        :duration (= ?duration (*(surfaceTable ?t)2))
        :condition (and 
            (over all(waiter ?w))
            (over all (atRobot ?t ?w))
            (at start (and (dirtyTable ?t) (not (free ?t)) (free ?w) (not (cleaning ?w))))
        )
        :effect (and 
            (at start (and (cleaning ?w)))
            (at end (and (not (dirtyTable ?t)) (not (cleaning ?w)) (free ?t)))
        )
    )

    
)