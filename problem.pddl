(define(problem Problem1)
    
    (:domain domain_robot)
    
    (:objects
        waiter barista - robot
        tr - object
        d1 d2 - drinkCold
    )

    (:init
        (tableToServe table2) 
        (tableMaking table2)

        (=(connection table1 bar)2)
        (=(connection table2 bar)2)
        (=(connection table3 bar)2)
        (=(connection table4 bar)2)

        (=(connection table1 table2)1)
        (=(connection table1 table3)1)
        (=(connection table1 table4)1)

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
        
        (tray tr) (free waiter) (free barista) (free tr)
        (atTray bar tr)
        (atRobot bar barista)
        (atRobot bar waiter)
        (=(toMakeCold table2)2)

        (dirtyTable table3) (dirtyTable table4)

    )

    (:goal 
        (and 
            (free table3) (free table4)(free table2)
        )
    )
)