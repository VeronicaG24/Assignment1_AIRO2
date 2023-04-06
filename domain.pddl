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
        bar table1 table2 table3 table4 - location ;location tables+bar
        onGrabber onTray - location ;where drinks are 
    )

    (:predicates
        (waiter ?w -robot)
        (barista ?b -robot)
        (tray ?t)
        (at ?d ?loc -location) ;stands for barista, waiter or drink at location
        (free ?d) ;we use it for waiter, barista and tables
        (dirtyTable ?loc-location) ;dirty table
        (cleaning ?w-robot) ;table that is being cleaning
        (tableToServe ?table -location) ;table to serve
        (tableMaking ?table -location) ;table for which the barista is making the drinks
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
    )



    (:action pickDrinkHot
        :parameters (?d -drinkHot ?w -robot ?table -location) 
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (at ?w bar)
            (free ?w)
            (=(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (not (at ?d bar))
            (at ?d onGrabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeHot ?table)1)
        )
    )

    (:action pickDrinkCold
        :parameters (?d -drinkCold ?w -robot ?table -location)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (at ?w bar)
            (free ?w)
            (=(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (not (at ?d bar))
            (at ?d onGrabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeCold ?table)1)
        )
    )

    (:action loadTrayHot
        :parameters (?d -drinkHot ?w -robot ?tray ?table -location)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (>=(numPlaceOnTray)1)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (>(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (decrease(toServeHot ?table)1)
            (at ?d onTray)
            (decrease (numPlaceOnTray) 1)
        )  
    )

    (:action loadTrayCold
        :parameters (?d -drinkCold ?w -robot ?tray ?table -location)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (>=(numPlaceOnTray)1)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (>(+(toServeHot ?table)(toServeCold ?table))1)
        )
        :effect (and
            (decrease(toServeCold ?table)1)
            (at ?d onTray)
            (decrease (numPlaceOnTray)1)
        ) 
    )

    (:action pickTray
        :parameters (?w -robot ?tray ?table -location)
        :precondition (and
            (waiter ?w)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (or (=(numPlaceOnTray)0) (and (<(numPlaceOnTray)2)(=(+(toServeHot ?table)(toServeCold ?table))1)))
        )
        :effect (and
            (assign(waiterSpeed ?w)1)
            (not(free ?w))
            (not (free ?tray))
        )
    )

    (:action serveDrinkHot
        :parameters (?d -drinkHot ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (at ?d onGrabber)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onGrabber))
            (at ?d ?table)
            (decrease(toServeHot ?table)1)
            (increase(servedHot ?table)1)
        )
    )

    (:action serveDrinkCold
        :parameters (?d -drinkCold ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (at ?d onGrabber)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onGrabber))
            (at ?d ?table)
            (decrease(toServeCold ?table)1)
            (increase(servedCold ?table)1)
        )
    )

    (:action serveTrayHot
        :parameters (?d -drinkHot ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (at ?d onTray)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onTray))
            (at ?d ?table)
            (decrease(toServeHot ?table)1)
            (increase(servedHot ?table)1)
        )
    )

    (:action serveTrayCold
        :parameters (?d -drinkCold ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (at ?d onTray)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onTray))
            (at ?d ?table)
            (decrease(toServeCold ?table)1)
            (increase(servedCold ?table)1)
        )
    )

    (:action releaseTray
        :parameters (?w -robot ?table - location ?tray)
        :precondition (and
            (waiter ?w)
            (at ?w bar)
            (tray ?tray)
            (=(numPlaceOnTray)3)
            (not (free ?w))
        )
        :effect (and
            (free ?w)
            (free ?tray)
            (at ?tray bar)
        )
    )

    (:action manageService
        :parameters (?table - location)
        :precondition (and 
            (not(tableToServe ?table))
            (free ?table)
        )
        :effect  
            (tableToServe ?table)
    )

    (:action manageMaking
        :parameters (?table - location)
        :precondition
           (not(tableMaking ?table))
        :effect 
            (tableMaking ?table)
    )

    (:durative-action move
        :parameters (?t1 ?t2 - location ?w -robot)
        :duration (= ?duration (/(connection ?t1 ?t2)(waiterSpeed ?w)))
        :condition (and 
            (over all(waiter ?w)) 
            (at start (and (at ?w ?t1) (not (free ?t2)) (not (cleaning ?w))))
        )
        :effect (and 
            (at end (and (not (at ?w ?t1)) (at ?w ?t2)))
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
                (and (at ?d bar) (decrease(toMakeCold ?table)1) (increase(toServeCold ?table)1) (free ?b))
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
            (at end (and (at ?d bar) (decrease(toMakeHot ?table)1) (increase(toServeHot ?table)1) (free ?b)))
        )
    )
    
    (:durative-action cleanTable
        :parameters (?t - location ?w -robot)
        :duration (= ?duration (*(surfaceTable ?t)2))
        :condition (and 
            (over all(waiter ?w))
            (at start (and (dirtyTable ?t) (at ?w ?t) (not (free ?t)) (free ?w) (not (cleaning ?w))))
        )
        :effect (and 
            (at start (and (cleaning ?w)))
            (at end (and (not (dirtyTable ?t)) (not (cleaning ?w)) (free ?t)))
        )
    )

    
)