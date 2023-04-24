(define (problem p1) (:domain bar)
(:objects 
    b -barista
    w1 w2 -waiter
    d1 d2 - drinkCold
    grab1 grab2 -location
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

    (=(waiterSpeed w1)2)
    (=(waiterSpeed w2)2)

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

    (belongs grab1 w1)
    (belongs grab2 w2)

    (toServe table2)

    (isAt w1 bar)
    (isAt w2 table1)

    (occupied bar)
    (occupied table1)
    (occupied grab1)
    (occupied grab2)
    (occupied onTray)

    (free b)
    (free w1)
    (free w2)

    (free table1)
    
    (isDirty table3)
    (isDirty table4)

    (toPrepareCold d1 table2)
    (toPrepareCold d2 table2)
)

(:goal (and
    (free table2)
    (free table3)
    (free table4)
))

)
