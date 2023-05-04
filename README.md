First assignment AIRo2
================================

This is a possible implementation of the first assignment of Artificial Intelligence for Robotics 2 course. 

The goal of this assignment is to model a robotic coffee shop solution for managing the orders made by the customers.

The repository is organized as it follows:
* The `report_groupD.pdf` file with the report of the assignment.
* The `requirements.pdf` file containing all the requiremnts of the assigment.
* The `domain.pddl` file with all the actions, durative-actions, types, predicates and functions to reach the goal of each problem, respecting the specific requests of the assignment.
* The `problem1.pddl` file contining the initialization and the goal for reaching the first problem specifications.
* The `problem2.pddl` file contining the initialization and the goal for reaching the second problem specifications.
* The `problem3.pddl` file contining the initialization and the goal for reaching the third problem specifications.
* The `problem4.pddl` file contining the initialization and the goal for reaching the fourth problem specifications.
* The `lpg++` executable, to use for planning with LPG++.
* The `lpg-td` executable, to use for planning with LPG-TD.
* The `README_LPGTD` file with specific instruction of LPG-TD planner.
* The `README.md` file with specifications of the solution proposed.

How to run
----------------------

To launch the assignment is necessary to clone the GitHub repository using:

```bash
git clone https://github.com/Matteoforni1/AIRO2_Assignment1.git
```

and inside there is the problem files, the domain file, and the two planners compatible (LPG-TD and LPG++).

Then from the folder, run the following command:

* For LPG-TD planner:
    ```bash
    ./lpg-td -o domain.pddl -f <problem file>.pddl -n 1
    ```

* For LPG++ planner:
    ```bash
    ./lpg++ -o domain.pddl -f <problem file>.pddl -n 1
    ```

`<problem file>.pddl` needs to be substitute with the specific name of the file of the problem you want to solve. <br /> Remember that the previous commands are some of possibile settings wherewith you can generate the solutions for the problems; there are others that are discussed in the report and here we have only reported the ones are used for generates the solution files in the our zip.

Structure of the code
----------------------

The domain and the problem files are designed to respect the following requirements:

* Problems:
    1. There are 2 customers at table 2: they ordered 2 cold drinks. Tables 3 and 4 need to be cleaned. 
    2. There are 4 customers at table 3: they ordered 2 cold drinks and 2 warm drinks. Table 1 needs to be cleaned.
    3. There are 2 customers at table 4: they ordered 2 warm drinks. There are also 2 customers at table 1: they ordered 2 warm drinks. Table 3 needs to be cleaned.
    4. There are 2 customers at table 4 and 2 customers at table 1: they all ordered cold drinks. There are also 4 customers at table 3: they all ordered warm drinks. Table 4 needs to be cleaned.
* Domain:

    Contains all the actions, durative-actions, types, predicates and functions to reach the goal of each problem, respecting the specific requests of the assignment.

