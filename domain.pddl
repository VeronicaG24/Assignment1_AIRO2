;Header and description

(define (domain domain_robot)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

    (:types 
        drinkHot
        drinkCold
        location
        slot
        waiter
        barista
        slot
    )

    ; un-comment following line if constants are needed
    (:constants 
        maxNumPlaceTray - number;maximum number of drinks in a tray
        table0 table1 table2 table3 table4 - location ;number of tables+bar
    )

    (:init
         (=maxNumPlaceTray 3)
    )
    (:predicates ;todo: define predicates here
        (table ?loc-location) ;this stands for the 4 table 
        (grabber ?loc -location) ; we use it for single drink
        (at ?d ?loc - location) ;stands for barista, waiter or drink at location
        (tray ?loc -location)   ; tray is a location
        (free ?d) ;we use it for waiter, barista and tables
        (dirtyTable ?loc-location) ;dirty table
    )


    (:functions ;todo: define numeric functions here
        (connection ?l1-location ?l2-location);this is the distance between bar and tables
        (waiterSpeed ?waiter-waiter) ;this is the speed of waiter
        (numPlaceOnTray) ;free places on tray
        (orderCold ?loc – location) ;number of cold drink per table
        (orderHot ?loc – location)  ;number of hot drink per table
        (surfaceTable ?loc – location ) ;stands for the surface of table
    )


    (:action pickDrinkHot
        :parameters (?table0-location ?d -drinkHot ?w -waiter ?loc -location)
        :precondition (and
            (at ?d ?table0)
            (free ?w)
            (grabber ?table0)
            (=(+(orderHot ?loc)(orderCold ?loc))1)
        )
        :effect (and
            (assign(waiterSpeed)2)
            (not(free ?w))
            (decrease(orderHot ?loc)1)
        )
    )

     (:action pickDrinkCold
        :parameters (?table0-location ?d -drinkCold ?w -waiter ?loc -location)
        :precondition (and
            (at ?d ?table0)
            (free ?w)
            (grabber ?table0 -location)
            (= (+(orderHot ?loc)(orderCold ?loc))1)
        )
        :effect (and
            (assign(waiterSpeed)2)
            (not(free ?w -waiter))
            (decrease(orderCold ?loc-location))
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