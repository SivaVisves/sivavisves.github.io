# This file was generated, do not modify it. # hide
# placing shadow prices of individual constraints in a list for printing
constraint = [JuMP.shadow_price(constraint1), JuMP.shadow_price(constraint2)]

#Printing the dual variables
println("Dual Variables:")
for j in 1:2
  println("dual[$j] = ", constraint[j])
end