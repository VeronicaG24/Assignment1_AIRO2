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
        maxNumPlaceTray - number ;maximum number of drinks in a tray
        bar table1 table2 table3 table4 - location ;location tables+bar
        (tableToServe 1 4 - number) ;number of the table to serve
        (grabber tray - location)
    )

    (:init
        (=maxNumPlaceTray 3)
    )
    (:predicates ;todo: define predicates here
        (waiter ?w -robot)
        (barista ?b -robot)
        ;(table ?loc-location) ;this stands for the 4 table 
        ;(grabber ?loc -location) ; we use it for single drink
        (at ?d ?loc - location) ;stands for barista, waiter or drink at location
        ;(tray ?loc -location)   ; tray is a location
        (free ?d) ;we use it for waiter, barista and tables
        (dirtyTable ?loc-location) ;dirty table
    )


    (:functions ;todo: define numeric functions here
        (connection ?l1-location ?l2-location);this is the distance between bar and tables
        (waiterSpeed ?waiter-waiter) ;this is the speed of waiter
        (numPlaceOnTray) ;free places on tray
        
        (toMakeCold ?table – number) ;number of cold drink per table to make
        (toMakeHot ?table – number)  ;number of hot drink per table to make
        (toServeCold ?table – number) ;number of cold drink per table to serve
        (toServeHot ?table – number)  ;number of hot drink per table to serve
        (servedCold ?table – number) ;number of cold drink per table served
        (servedHot ?table – number)  ;number of hot drink per table served

        (surfaceTable ?loc – location ) ;stands for the surface of table 
        (numberTable ?loc – location) ;stands for the number of table
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
            (at ?d grabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeHot ?loc)1)
        )
    )

    (:action pickDrinkHot
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
            (at ?d grabber)
            (assign(waiterSpeed ?w)2)
            (not(free ?w))
            (decrease(toServeCold ?loc)1)
        )
    )

    (:action loadTrayHot
        :parameters (?tray -location ?table -location ?d-drinkHot)
        :precondition (and
            (at ?d-drinkHot ?table0 -location)
            (>=(numPlaceOnTray )1)
            (at ?w -waiter ?table0 -location)
            (>(+(orderHot ?table)(orderHot ?table)))1)
        :effect (and
            (decrease(orderHot ?table)1)
            (at ?d - drinkHot ?tray)
            (decrease (numPlaceOnTray) 1)
        )  
    )

     (:action loadTrayCold
        :parameters (?tray -location ?table -location ?d-drinkCold)
        :precondition (and
            (at ?d-drinkCold ?table0 -location)
            (>=(numPlaceOnTray )1)
            (at ?w -waiter ?table0 -location)
            (>(+(orderHot ?table)(orderCold ?table)))1)
        :effect (and
            (decrease(orderCold ?table)1)
            (at ?d - drinkCold ?tray)
            (decrease (numPlaceOnTray) 1)
        )  
    )




)