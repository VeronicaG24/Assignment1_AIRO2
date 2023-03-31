;Header and description

(define (domain domain_robot)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

    (:types 
        location
        robot
        drinkHot
        drinkCold
    )

    ; un-comment following line if constants are needed
    (:constants 
        (maxNumPlaceTray - number) ;maximum number of drinks in a tray
        (bar table1 table2 table3 table4 - location);location tables+bar
        (tableToServe 1 4 - number) ;number of the table to serve
        (tableMaking 1 4 - number) ;number of the table that the barista is making the drinks
        (onGrabber onTray - location)
    )

    (:init
        (=(maxNumPlaceTray) 3)
        (=(table-has-number bar) 0)
        (=(table-has-number table1) 1)
        (=(table-has-number table2) 2)
        (=(table-has-umber table3) 3)
        (=(table-has-number table4) 4)
        (=(tableMaking) 1)
    )
    (:predicates ;todo: define predicates here
        (waiter ?w -robot)
        (barista ?b -robot)
        (tray ?t)
        ;(table ?loc-location) ;this stands for the 4 table 
        ;(grabber ?loc -location) ; we use it for single drink
        (at ?d ?loc) ;stands for barista, waiter or drink at location
        ;(tray ?loc -location)   ; tray is a location
        (drinks-for-table ?table - location) ;total num of drink for table
        (free ?d) ;we use it for waiter, barista and tables
        (dirtyTable ?loc-location) ;dirty table
        (cleaning ?w-robot)
    )


    (:functions ;todo: define numeric functions here
        (connection ?l1-location ?l2-location);this is the distance between bar and tables
        (waiterSpeed ?r-robot) ;this is the speed of waiter
        (numPlaceOnTray) ;free places on tray
        
        (toMakeCold ?table – number) ;number of cold drink per table to make
        (toMakeHot ?table – number)  ;number of hot drink per table to make
        (toServeCold ?table – number) ;number of cold drink per table to serve
        (toServeHot ?table – number)  ;number of hot drink per table to serve
        (servedCold ?table – number) ;number of cold drink per table served
        (servedHot ?table – number)  ;number of hot drink per table served

        (surfaceTable ?loc – location) ;stands for the surface of table
        (table-has-number ?loc-location) ;associate number of table with table
    )


    (:action pickDrinkHot
        :parameters (?d -drinkHot ?w -robot)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (at ?w bar)
            (free ?w)
            (=(+(toServeHot tableToServe)(toServeCold tableToServe))1)
        )
        :effect (and
            (not (at ?d bar))
            (at ?d onGrabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeHot tableToServe)1)
        )
    )

    (:action pickDrinkCold
        :parameters (?d -drinkCold ?w -robot)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (at ?w bar)
            (free ?w)
            (=(+(toServeHot tableToServe)(toServeCold tableToServe))1)
        )
        :effect (and
            (not (at ?d bar))
            (at ?d onGrabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeCold tableToServe)1)
        )
    )

    (:action loadTrayHot
        :parameters (?d-drinkHot ?w -robot ?tray)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (>=(numPlaceOnTray)1)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (>(+(toServeHot tableToServe)(toServeCold tableToServe)))1)
        :effect (and
            (decrease(toServeHot tableToServe)1)
            (at ?d onTray)
            (decrease (numPlaceOnTray) 1)
        )  
    )

    (:action loadTrayCold
        :parameters (?d-drinkCold ?w -robot)
        :precondition (and
            (waiter ?w)
            (at ?d bar)
            (>=(numPlaceOnTray)1)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (>(+(toServeHot tableToServe)(toServeCold tableToServe)))1)
        :effect (and
            (decrease(toServeCold tableToServe)1)
            (at ?d onTray)
            (decrease (numPlaceOnTray) 1)
        ) 
    )

    (:action pickTray
        :parameters (?w -robot ?tray)
        :precondition (and
            (waiter ?w)
            (at ?w bar)
            (free ?w)
            (tray ?tray)
            (at ?tray bar)
            (or (=(numPlaceOnTray)0) (and((<(numPlaceOnTray)2)(=(+(toServeHot tableToServe)(toServeCold tableToServe))1))))
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
            (=(table-has-number ?table)tableToServe)
            (at ?d onGrabber)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onGrabber))
            (at ?d ?table)
            (decrease(toServeHot tableToServe)1)
            (increase(servedHot tableToServe)1)
        )
    )

    (:action serveDrinkCold
        :parameters (?d -drinkCold ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (=(table-has-number ?table)tableToServe)
            (at ?d onGrabber)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onGrabber))
            (at ?d ?table)
            (decrease(toServeCold tableToServe)1)
            (increase(servedCold tableToServe)1)
        )
    )

    (:action serveTrayHot
        :parameters (?d -drinkHot ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (=(table-has-number ?table)tableToServe)
            (at ?d onTray)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onTray))
            (at ?d ?table)
            (decrease(toServeHot tableToServe)1)
            (increase(servedHot tableToServe)1)
        )
    )

    (:action serveTrayCold
        :parameters (?d -drinkCold ?w -robot ?table - location)
        :precondition (and
            (waiter ?w)
            (at ?w ?table)
            (=(table-has-number ?table)tableToServe)
            (at ?d onTray)
            (not (free ?w))
        )
        :effect (and
            (not (at ?d onTray))
            (at ?d ?table)
            (decrease(toServeCold tableToServe)1)
            (increase(servedCold tableToServe)1)
        )
    )

    (:action releaseTray
        :parameters (?w -robot ?table - location ?tray)
        :precondition (and
            (waiter ?w)
            (at ?w bar)
            (tray ?tray)
            (=(numPlaceOnTray)maxNumPlaceTray)
            (not (free ?w))
        )
        :effect (and
            (free ?w)
            (free ?tray)
            (at ?tray bar)
        )
    )

    (:action manageService
        :parameters ()
        :precondition (and 
            (<=(tableToServe)4)
            (=(+(servedHot tableToServe)(servedCold tableToServe))drinks-for-table tableToServe)
        )
        :effect (and 
            (assign(tableToServe)tableMaking)
        )
    )

    (:action manageMaking
        :parameters ()
        :precondition (and 
            (<=(tableMaking)4)
            (=(+(toMakeHot tableMaking)(servedCold tableMaking))0)
        )
        :effect (and 
            (increase(tableMaking)1)
        )
    )

    (:durative-action move
        :parameters (?t1 ?t2 - location ?w -robot)
        :duration (= ?duration (/(connection ?t1 ?t2)(waiterSpeed ?w)))
        :condition (and (waiter ?w)
            (at start (and (at ?w ?t1) (not (free ?t2) (not (cleaning ?w)))
            ))
        )
        :effect (and 
            (at end (and (not (at ?w ?t1)) (at ?w ?t2)
            ))
        )
    )
    
    (:durative-action prepareCold
        :parameters (?b -robot ?d - drinkCold ?table - location)
        :duration (= ?duration 3)
        :condition (and (barista ?b)
            (at start (and (not (at ?d ?table)) (>(toMakeCold tableToServe)0)
            ))
            (over all (and 
            ))
            (at end (and 
            ))
        )
        :effect (and 
            (at start (and (not (free ?b))
            ))
            (at end (and (at ?d ?table) (decrease(toMakeCold tableToServe)1) (increase(toServeCold tabletoserve)1) (free ?b)
            ))
        )
    )

    (:durative-action prepareHot
        :parameters (?b ?w -robot ?d - drinkHot ?table - location)
        :duration (= ?duration 5)
        :condition (and (waiter ?w) (barista ?b)
            (at start (and (not (at ?d ?table)) (>(toMakeHot tableToServe)0) (free ?w)
            ))
            (over all (and
            ))
            (at end (and (free ?w)
            ))
        )
        :effect (and 
            (at start (and (not (free ?b))
            ))
            (at end (and (at ?d ?table) (decrease(toMakeHot tableToServe)1) (increase(toServeHot tabletoserve)1) (free ?b)
            ))
        )
    )
    
    (:durative-action cleanTable
        :parameters (?t - location ?w -robot)
        :duration (= ?duration (*(surfaceTable ?t)2))
        :condition (and (waiter ?w)
            (at start (and (dirtyTable ?t) (at ?w ?t) (not (free ?t)) (free ?w)
            ))
            (over all (and 
            ))
            (at end (and 
            ))
        )
        :effect (and 
            (at start (and (cleaning ?w)
            ))
            (at end (and (not (dirtyTable ?t)) (not (cleaning ?w))
            ))
        )
    )
)
