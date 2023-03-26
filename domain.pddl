;Header and description

(define (domain domain_robot)

    ;remove requirements that are not needed
    (:requirements :strips :fluents :durative-actions :timed-initial-literals :typing :conditional-effects :negative-preconditions :duration-inequalities :equality)

    (:types ;todo: enumerate types and their hierarchy here, e.g. car truck bus - vehicle
        drink
        tray
        table
        bar
    )

    ; un-comment following line if constants are needed
    (:constants 
        (maxNumPlaceTray 3 - numPlace) ;maximum number of drinks in a tray
    )

    (:predicates ;todo: define predicates here
        (waiter ?waiter) ;waiter
        (barista ?barista) ;barista
        (customer ?customer) ;customer
        (location ?loc) ;location

        (at-waiter ?w - waiter ?loc - location) ;waiter at location
        
        (orderBy ?order ?table) ;order by table
        (sittedAt ?table ?customer) ;customer sitted at table
        (freeTable ?table) ;free table = clean table
        (drinkHot ?dh) ;drink hot 5 time units
        (drinkCold ?dc) ;drink cold 3 time units
        
        (freeWaiter ?freeWaiter) ;free waiter
        (dirtyTable ?dt) ;dirty table

        (freeTray ?ft) ;free tray
        (freePlaceOnTray ?tray ?numPlace) ;free place on tray
        ;(numPlace ?np) ;number of place on tray

        )


    (:functions ;todo: define numeric functions here
        (numPlaceFree) ;number of free place on tray
        (numDrinks) ;number of drinks in order
        (freePlaceOnTray ?numPlace - tray)
    )

    ;define actions here
    (:action carryTray
        :parameters (?waiter - waiter ?tray - tray)
        :precondition (and (freeWaiter ?waiter)  (<= (freePlaceOnTray ?numPlace)1)  (>= (freePlaceOnTray ?numPlace)0))
        :effect (and (not (freeWaiter ?waiter)) (not (freeTray ?tray)))
    )

    (:action loadTray
        :parameters (?tray - tray ?waiter - waiter ?loc - bar)
        :precondition (and 
            (at-waiter ?waiter ?loc)
            (freeTray ?tray)
            (freeWaiter ?waiter)
            (>= (freePlaceOnTray ?numPlace)1)
            (>= (numPlaceFree) 1)
        )
        :effect (and 
            ((decrease (numPlaceFree) 1))
            (assign (freePlaceOnTray ?numPlace)numPlaceFree) ;TO CHECK
        )
        )
    )