# Combination-Permutation-Calculator
Texas Tech Assembly Language Course, Final Project
Description
--------------------------------------------------
Create an assembly program that will calculate a user's choice of either combination orpermutation. Everything will be written in assembly except for the i/o functions. For i/o your program will use printf and scanf (how to do this will be demonstrated in class). Your main procedure will print a menu for the user and read their input. They will be able to select an option (combination or permutation) and then your program will calculate the appropriate operation after asking them for the appropriate inputs (combination and permutation formulas can be found online and will be discussed in class). You should have at least 3 additional procedures besides the main procedure: factorial, combination and permutation. You may have more if you wish. Factorial should be a recursively defined procedure that takes an integer argument (passed on the stack) and returns it's factorial. The combination and permutation procedures will use the factorial procedure that you create in order to perform their calculations. After each selection the user should be asked if they would like to perform another operation. If they enter "yes" (not just 'y') they should be able to continue. Otherwise, the program should exit