(define (problem p) (:domain bar)
(:objects 
    b -barista
    w -waiter
    d1 d2 -drinkCold
    d3 -drinkHot
    b1 b2 b3 -biscuit
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

    (=(waiterSpeed w)2)

    (=(numPlaceOnTray)3)

    (isAt w bar)

    (free b)
    (free w)

    (toPrepareCold d1 table1)
    (toprepareCold d2 table3)
    (toPrepareHot d3 table4)
)

(:goal (and
    
))

)
