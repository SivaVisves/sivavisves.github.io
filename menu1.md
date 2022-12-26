+++
title = "Simple Linear Program"
hascode = true
date = Date(2019, 3, 22)
rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/3/32/Rick_and_Morty_opening_credits.jpeg)"

tags = ["syntax", "code"]
+++


@def title = "Simple Linear ProgrAM"
@def hasmath = true
@def hascode = true

# Simple Linear Program Using Julia 
\toc

## 2.1 LP Problems

Below will be the LP problem that will be used for this example:-

$$ \max x_1 + 2x_2 + 5x_3 $$

subject to
$$ -x_1 + x_2 + 3x_3 \leq 5$$
$$ x_1 + 3x_2 - 7x_3 \leq 10$$
$$ 0 \leq x_1 \leq 10 $$
$$ x_2 \geq 0$$
$$ x_3 \geq 0$$

```julia:./ex1
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
```

\output{./ex1}

```julia:./ex2
# Solving the optimization problem
JuMP.optimize!(m)

# Printing the optimal solutions obtained
println("Objective value: ", JuMP.objective_value(m))

println("Optimal Solutions:")
println("x1 = ", JuMP.value(x1))
println("x2 = ", JuMP.value(x2))
println("x3 = ", JuMP.value(x3))
```
\output{./ex2}

**Shadow prices**: Calculating the effect on the objective value if the RHS of the constraint equation is increased by one.

```julia:./ex3
# Printing the optimal dual variables
println("Dual Variables:")
println("dual1 = ", JuMP.shadow_price(constraint1))
println("dual2 = ", JuMP.shadow_price(constraint2))
```

\output{./ex3}

## 2.2 Alternative Ways of Writing LP
```julia:./ex4
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
```
What we have so far after adding different variables in model "m"
\output{./ex4}

Below are alternative ways to defining constraints. Uncomment to see how it works. To unregister constraints, use 'unregister(model, :constraint#)'

```julia:./ex5

#-------------Alternative ways of coding constraints----------------------------------


#-------------Alternative 1-----------------------------------------------------------
# constraint = Dict()
# for j in 1:2
#   constraint[j] = @constraint(m, sum(A[j,i]*x[i] for i in 1:3) <= b[j])
# end


#-------------Alternative 2-----------------------------------------------------------
# @constraint(m, constraint[j in 1:2], sum(A[j,i]*x[i] for i in 1:3) <= b[j])
```
Finally we add bounds for variable x1 and optimize accordingly

```julia:./ex6
#adding bounds for the value of x[1]
@constraint(m, bound, x[1] <=10)

JuMP.optimize!(m)

#Printing the optimal values

println("Objective value: ", JuMP.objective_value(m))


println("Optimal Solutions:")
for i in 1:3
    println("x[$i] = ", JuMP.value(x[i]))
end
```

\output{./ex6}

And we find out the shadow variables in our model:

```julia:./ex7
# placing shadow prices of individual constraints in a list for printing
constraint = [JuMP.shadow_price(constraint1), JuMP.shadow_price(constraint2)]

#Printing the dual variables
println("Dual Variables:")
for j in 1:2
  println("dual[$j] = ", constraint[j])
end
```

\output{./ex7}

## 2.3 Yet Another Way of Writing LP Problems
In section 2.2, to change the data and solve another probelm with the same structure, individual lists would need to be updates. This could be rather tedious. Here is another way to updating values.

```julia:./ex8
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
```

\output{./ex8}

## 2.4 Mixed Integer Linear Programming (MILP) Problems

<!-- # Working with code blocks

\toc

## Live evaluation of code blocks

If you would like to show code as well as what the code outputs, you only need to specify where the script corresponding to the code block will be saved.

Indeed, what happens is that the code block gets saved as a script which then gets executed.
This also allows for that block to not be re-executed every time you change something _else_ on the page.

Here's a simple example (change values in `a` to see the results being live updated):

```julia:./exdot.jl
using LinearAlgebra
a = [1, 2, 3, 3, 4, 5, 2, 2]
@show dot(a, a)
println(dot(a, a))
```

You can now show what this would look like:

\output{./exdot.jl}

**Notes**:
* you don't have to specify the `.jl` (see below),
* you do need to explicitly use print statements or `@show` for things to show, so just leaving a variable at the end like you would in the REPL will show nothing,
* only Julia code blocks are supported at the moment, there may be a support for scripting languages like `R` or `python` in the future,
* the way you specify the path is important; see [the docs](https://tlienart.github.io/franklindocs/code/index.html#more_on_paths) for more info. If you don't care about how things are structured in your `/assets/` folder, just use `./scriptname.jl`. If you want things to be grouped, use `./group/scriptname.jl`. For more involved uses, see the docs.

Lastly, it's important to realise that if you don't change the content of the code, then that code will only be executed _once_ even if you make multiple changes to the text around it.

Here's another example,

```julia:./code/ex2
for i ∈ 1:5, j ∈ 1:5
    print(" ", rpad("*"^i,5), lpad("*"^(6-i),5), j==5 ? "\n" : " "^4)
end
```

which gives the (utterly useless):

\output{./code/ex2}

note the absence of `.jl`, it's inferred.

You can also hide lines (that will be executed nonetheless):

```julia:./code/ex3
using Random
Random.seed!(1) # hide
@show randn(2)
```

\output{./code/ex3}


## Including scripts

Another approach is to include the content of a script that has already been executed.
This can be an alternative to the description above if you'd like to only run the code once because it's particularly slow or because it's not Julia code.
For this you can use the `\input` command specifying which language it should be tagged as:


\input{julia}{/_assets/scripts/script1.jl} <!--_-->


<!-- these scripts can be run in such a way that their output is also saved to file, see `scripts/generate_results.jl` for instance, and you can then also input the results:

\output{/_assets/scripts/script1.jl} <!--_-->

<!-- which is convenient if you're presenting code.

**Note**: paths specification matters, see [the docs](https://tlienart.github.io/franklindocs/code/index.html#more_on_paths) for details.

Using this approach with the `generate_results.jl` file also makes sure that all the code on your website works and that all results match the code which makes maintenance easier. --> 
