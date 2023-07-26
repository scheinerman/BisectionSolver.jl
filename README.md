# `BisectionSolver`

Solve equations by the bisection method. 

## The function `bisection_solve`

To solve an equation of the form `f(x) == 0` we call `bisection_solve(f,a,b)`
where `a` and `b` are either scalars or vectors such that `f(a)` and `f(b)`
have opposite signs. It is vital that `f` be a real-valued continuous function.

```
julia> f(x) = x^2-2
f (generic function with 1 method)

julia> bisection_solve(f,1,2)
1.4142136573791504

julia> sqrt(2)
1.4142135623730951

julia> f(x) = x[1]^2 + x[2]^2 - 2
f (generic function with 1 method)

julia> bisection_solve(f,[1,3], [0,0])
2-element Vector{Float64}:
 0.44721364974975586
 1.3416409492492676

julia> f(ans)
4.852249730902258e-7
```

The arguments to the function may be complex:
```
julia> f(x) = x * x' - 2
f (generic function with 1 method)

julia> bisection_solve(f, 0im, 2im-3)
-1.176696538925171 + 0.7844643592834473im

julia> f(ans)
-9.242955343324866e-7 + 0.0im
```

### Opposite sign requirement
The initial values `a` and `b` must give function values with opposite signs or
an error is thrown.

```
julia> f(x) = x^2-2
f (generic function with 1 method)

julia> bisection_solve(f,2,3)
ERROR: Function values at 2 and 3 have the same sign
```

## Optional arguments

The function `bisection_solve` takes three optional named arguments:
* `max_steps` controls the maximum number of iterations of the bisection algorithm. The number of function calls is at most `max_steps+2`.
* `tol` controls the desired closeness to zero for the function value. The algorithm stops when `f(x) <= tol`. However, it never does more than `max_steps` iterations.
* `scaled` controls the way in which a new point between `a` and `b` is selected at each stage. When `scaled` is `false ` (the default) the midpoint is selected. When `scaled` is `true` we select a point `m` so that the segment from `(a,f(a))` to `(b,f(b))` passes through `(m,0)`. This may give better resutls.

```
julia> f(x) = x^2-2
f (generic function with 1 method)

julia> bisection_solve(f,1,2,max_steps=5)
1.40625

julia> ans^2
1.9775390625

julia> bisection_solve(f,1,2,max_steps=5,scaled=true)
1.4141414141414141

julia> ans^2
1.9997959391898785

```

