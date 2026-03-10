open System

let eps = 1e-6

// -------------------
// DICHOTOMY
// -------------------

let rec dichotomy f a b =
    let mid = (a + b) / 2.0
    if abs (b - a) < eps then mid
    else
        if f a * f mid <= 0.0 then
            dichotomy f a mid
        else
            dichotomy f mid b


// -------------------
// NEWTON
// -------------------

let rec newton f df x =
    let x1 = x - f x / df x
    if abs (x1 - x) < eps then x1
    else newton f df x1


// -------------------
// ITERATIONS
// -------------------

let rec iterations phi x =
    let x1 = phi x
    if abs (x1 - x) < eps then x1
    else iterations phi x1


// ===================
// EQUATION 18
// ===================

let f18 x =
    x + sqrt x + x ** (1.0/3.0) - 2.5

let df18 x =
    1.0 + 1.0/(2.0*sqrt x) + (1.0/3.0)*(x ** (-2.0/3.0))

let phi18 x =
    2.5 - sqrt x - x ** (1.0/3.0)


// ===================
// EQUATION 19
// ===================

let f19 x =
    x - 1.0 / (3.0 + sin(3.6*x))

let df19 x =
    1.0 - (3.6*cos(3.6*x)) / ((3.0 + sin(3.6*x))**2.0)

let phi19 x =
    1.0 / (3.0 + sin(3.6*x))


// ===================
// EQUATION 20
// ===================

let f20 x =
    0.1*x*x - x*log x

let df20 x =
    0.2*x - log x - 1.0

let phi20 x =
    (log x) / 0.1


// -------------------
// SOLVE
// -------------------

let solve name f df phi a b start =
    let d = dichotomy f a b
    let n = newton f df start
    let i = iterations phi start

    printfn "%s" name
    printfn "Dichotomy: %.6f" d
    printfn "Newton:    %.6f" n
    printfn "Iterations:%.6f\n" i


solve "Equation 18" f18 df18 phi18 0.4 1.0 0.7
solve "Equation 19" f19 df19 phi19 0.0 0.85 0.4
solve "Equation 20" f20 df20 phi20 1.0 2.0 1.5