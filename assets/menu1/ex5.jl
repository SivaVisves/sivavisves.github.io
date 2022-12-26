# This file was generated, do not modify it. # hide
#-------------Alternative ways of coding constraints----------------------------------


#-------------Alternative 1-----------------------------------------------------------
# constraint = Dict()
# for j in 1:2
#   constraint[j] = @constraint(m, sum(A[j,i]*x[i] for i in 1:3) <= b[j])
# end


#-------------Alternative 2-----------------------------------------------------------
# @constraint(m, constraint[j in 1:2], sum(A[j,i]*x[i] for i in 1:3) <= b[j])