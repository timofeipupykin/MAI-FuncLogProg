open System

let eps = 1e-6

// точная функция
let f x =
    ((1.0 + x*x) / 2.0) * atan(x) - x / 2.0

// член ряда
let term x n =
    let sign = if (n + 1) % 2 = 0 then -1.0 else 1.0
    sign * (float (pown x (2*n+1))) / float(4*n*n - 1)


// универсальный аналог while
let rec seriesWhile term next n sum =
    if abs term <= eps then
        (sum, n)
    else
        let newSum = sum + term
        let newTerm = next term n
        seriesWhile newTerm next (n + 1) newSum


// наивный ряд
let taylorDumb x =
    let firstTerm = term x 1

    let next _ n =
        term x (n + 1)

    seriesWhile firstTerm next 1 0.0


// умный ряд
let taylorSmart x =
    let firstTerm = x**3.0 / 3.0

    let next t n =
        -t *
        (x*x) *
        float(4*n*n - 1) /
        float(4*(n+1)*(n+1) - 1)

    seriesWhile firstTerm next 1 0.0


// границы
let a = 0.1
let b = 0.6
let points = 10

let step = (b - a) / float(points - 1)

printfn "x\tTaylor dumb\titer\tTaylor smart\titer\tf(x)"

[0 .. points-1]
|> List.map (fun i -> a + float i * step)
|> List.iter (fun x ->
    let (dumb, it1) = taylorDumb x
    let (smart, it2) = taylorSmart x
    let real = f x

    printfn "%.2f\t%.6f\t%d\t%.6f\t%d\t%.6f"
        x dumb it1 smart it2 real
)