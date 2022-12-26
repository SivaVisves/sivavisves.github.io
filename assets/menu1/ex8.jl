# This file was generated, do not modify it. # hide
using JuMP, GLPK

# Preparing an optimization model
m = Model(GLPK.Optimizer)

# adding indices to track constraints
index_x = 1:3
index_constraints = 1:2

A = [-1  1  3;
      1  3 -7]
b = [-5; 10]
c = [ 1; 2; 5]


@variable(m, x[index_x] >= 0)
@objective(m, Max, sum( c[i]*x[i] for i in index_x) )

#---------New way to define constraints--------------------
@constraint(m, constraint[j in index_constraints], 
                            sum( A[j,i]*x[i] for i in index_x ) <= b[j] )

print(m)