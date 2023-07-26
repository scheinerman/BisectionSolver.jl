module BisectionSolver

export bisection_solve

"""
    _mid_point(a,b)

Return the midpoint between `a` and `b`.
"""
function _true_mid_point(a, b)
    return  (a + b) / 2
end


"""
    _intercept_point(a, b, ya, yb)

Estimate a point between `a` and `b` using a 
straight line segment.
"""
function _intercept_point(a, b, ya, yb)
    m = (yb - ya) ./ (b - a)
    x = (a .* m .- ya) ./ m
    return x
end

"""
    _new_m(a, b, ya, yb, scaled::Bool)

Choose a point between `a` and `b`. If `scaled` is `true`, use 
`_intercept_point`. Otherwise, use `_true_mid_point`.
"""
function _new_m(a, b, ya, yb, scaled::Bool)
    if scaled
        return _intercept_point(a, b, ya, yb)
    else
        return _true_mid_point(a, b)
    end
end

"""
    bisection_solve(f::Function, a, b;
        max_steps::Int = 100, tol = 1e-6, scaled::Bool = false)

Solve the equation `f(x)=0` given intial guesses `a` and `b` such 
that `f(a)` and `f(b)` have opposite signs. `a` and `b` can be scalars or 
vectors. The values of `f` must be scalars.

* `max_steps` controls the number of iterations
* `tol` controls the closeness to zero consider success
* `scaled` determines the method by which a point between `a` and `b` is determined.
"""
function bisection_solve(
    f::Function,
    a,
    b;
    max_steps::Int = 100,
    tol = 1e-6,
    scaled::Bool = false,
)

    if tol < 0
        error("Tolerance set to $tol; must be nonnegative")
    end

    ya = f(a)
    if ya == 0
        return a
    end
    yb = f(b)
    if yb == 0
        return b
    end

    if sign(ya) == sign(yb)
        error("Function values at $a and $b have the same sign")
    end
    m = (a + b) ./ 2

    for _ = 1:max_steps
        m = _new_m(a, b, ya, yb, scaled)
        ym = f(m)

        if abs(ym) <= tol
            return m
        end

        if sign(ya) == sign(ym)
            a = m
            ya = ym
        else
            b = m
            yb = ym
        end
    end

    return m
end

end # module BisectionSolver
