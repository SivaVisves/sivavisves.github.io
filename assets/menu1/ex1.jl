# This file was generated, do not modify it. # hide
using JuMP, GLPK

# Preparing an optimization model
m = Model(GLPK.Optimizer)

#Declaring Variables 
@variable(m, 0<= x1 <=10)
@variable(m, x2 >= 0)
@variable(m, x3 >= 0)

#Setting objective function
@objective(m, Max, x1 + 2x2 + 5x3)

#adding constraints
@constraint(m, constraint1, -x1 +  x2 + 3x3 <= -5)
@constraint(m, constraint2,  x1 + 3x2 - 7x3 <= 10)


# Printing the prepared optimization model
print(m)