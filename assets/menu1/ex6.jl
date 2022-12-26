# This file was generated, do not modify it. # hide
#adding bounds for the value of x[1]
@constraint(m, bound, x[1] <=10)

JuMP.optimize!(m)

#Printing the optimal values

println("Objective value: ", JuMP.objective_value(m))


println("Optimal Solutions:")
for i in 1:3
    println("x[$i] = ", JuMP.value(x[i]))
end