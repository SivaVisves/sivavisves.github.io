# This file was generated, do not modify it. # hide
using JuMP, GLPK

# Preparing an optimization model
m = Model(GLPK.Optimizer)

# Setting Variable x
@variable(m, x[1:3] >= 0)

# Setting Variable C and Objective function
C = [1,2,5]

@objective(m, Max, sum(C[i]*x[i] for i in 1:3))

# Constraints definition in the form of a Matrix
A = [-1  1  3;
      1  3 -7]
b = [-5; 10]

@constraint(m, constraint1, sum( A[1,i]*x[i] for i in 1:3) <= b[1] )
@constraint(m, constraint2, sum( A[2,i]*x[i] for i in 1:3) <= b[2] )

print(m)