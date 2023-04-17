(define (problem p1) (:domain bar)
(:objects 
    b -barista
    w -waiter
    d1 d2 - drinkCold
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

    (=(numDrink table1)0)
    (=(numDrink table2)2)
    (=(numDrink table3)0)
    (=(numDrink table4)0)

    (=(numDrinkServed table1)0)
    (=(numDrinkServed table2)0)
    (=(numDrinkServed table3)0)
    (=(numDrinkServed table4)0)

    (=(numBiscuit table1)0)
    (=(numBiscuit table2)0)
    (=(numBiscuit table3)0)
    (=(numBiscuit table4)0)

    (toServe table2)

    (isAt w bar)

    (free b)
    (free w)

    (free table1)
    
    (isDirty table3)
    (isDirty table4)

    (isTable table1)
    (isTable table2)
    (isTable table3)
    (isTable table4)

    (toPrepareCold d1 table2)
    (toPrepareCold d2 table2)
)

(:goal (and
    (free table2)
    (free table3)
    (free table4)
))

)
