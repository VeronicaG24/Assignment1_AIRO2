(define(problem Problem1)
    
    (:domain domain_robot)
    
    (:objects
        waiter barista -robot
        tr -object
        d1 d2 -drinkCold
    )

    (:init

        (=(connection table1 bar)2)
        (=(connection table2 bar)2)
        (=(connection table3 bar)3)
        (=(connection table4 bar)3)
        (=(connection table1 table2)1)
        (=(connection table1 table3)1)
        (=(connection table1 table4)1)
        (=(connection bar table1)2)
        (=(connection bar table2)2)
        (=(connection bar table3)3)
        (=(connection bar table4)3)
        (=(connection table2 table1)1)
        (=(connection table2 table3)1)
        (=(connection table2 table4)1)
        (=(connection table3 table1)1)
        (=(connection table3 table2)1)
        (=(connection table3 table4)1)

        (=(connection table4 table1)1)
        (=(connection table4 table2)1)
        (=(connection table4 table3)1)
        
        (=(surfaceTable bar)1)
        (=(surfaceTable table1)1)
        (=(surfaceTable table2)1)
        (=(surfaceTable table3)2)
        (=(surfaceTable table4)1)
        (=(numPlaceOnTray )3)
        (=(waiterSpeed waiter)2)
        (tray tr) 
        (free waiter)
        (waiter waiter)
        (barista barista)
        (free barista) 
        (free tr)
        (atTray bar tr)
        (atRobot bar barista)
        (atRobot bar waiter)

        (=(toMakeCold table2)2)
        (=(toServeCold table2)0)
        (=(numdrink table2)2)

        (dirtyTable table3) (dirtyTable table4)

    )

    (:goal 
        (and 
            (atDrinkcold bar d1) (atDrinkcold bar d2)
        )
    )
)