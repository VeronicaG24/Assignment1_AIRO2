(define(problem Problem1)
    
    (:domain domain_robot)
    
    (:objects
        waiter barista - robot
        tr
        d1 d2 - drinkCold

    )

    (:init 
        (=(maxNumPlaceTray) 3)
        
        (=(table-has-number bar) 0)
        (=(table-has-number table1) 1)
        (=(table-has-number table2) 2)
        (=(table-has-umber table3) 3)
        (=(table-has-number table4) 4)
        
        (=(tableMaking) 1)

        (=(connection bar tabl1)2)
        (=(connection bar tabl2)2)
        (=(connection bar tabl3)4)
        (=(connection bar tabl4)4)

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

        (at tray bar)
        (at barista bar)
        (at waiter bar)

        (=(drink-for-table table2)2)
        (=(toMakeCold table2)2)

        (dirtyTable table3) (dirtyTable table4)

    )

    (:goal 
        (and 
            (free t3) (free t4)(free t2)
        )
    )
)