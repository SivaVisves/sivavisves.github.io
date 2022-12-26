# This file was generated, do not modify it. # hide
# Solving the optimization problem
JuMP.optimize!(m)

# Printing the optimal solutions obtained
println("Objective value: ", JuMP.objective_value(m))

println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))