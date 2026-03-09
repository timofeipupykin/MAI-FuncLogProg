open System

let eps = 1e-6

// точная функция
let f x =
    ((1.0 + x*x) / 2.0) * atan(x) - x / 2.0

// член ряда по формуле
let term x n =
    let sign = if (n+1) % 2 = 0 then -1.0 else 1.0
    sign * (pown x (2*n+1) |> float) / float(4*n*n - 1)

// dumb вычисление
let taylorDumb x =
    let mutable sum = 0.0
    let mutable n = 1
    let mutable t = term x n

    while abs t > eps do
        sum <- sum + t
        n <- n + 1
        t <- term x n

    (sum, n)

// smart вычисление
let taylorSmart x =
    let mutable n = 1
    let mutable t = x**3.0 / 3.0
    let mutable sum = t

    while abs t > eps do
        let next =
            -t *
            (x*x) *
            float(4*n*n - 1) /
            float(4*(n+1)*(n+1) - 1)

        t <- next
        sum <- sum + t
        n <- n + 1

    (sum, n)

// границы
let a = 0.1
let b = 0.6
let points = 10

let step = (b - a) / float(points - 1)

printfn "x\tTaylor dumb\titer\tTaylor smart\titer\tf(x)"

for i in 0 .. points-1 do
    let x = a + float(i) * step

    let (dumb, it1) = taylorDumb x
    let (smart, it2) = taylorSmart x
    let real = f x

    printfn "%.2f\t%.6f\t%d\t%.6f\t%d\t%.6f"
        x dumb it1 smart it2 real