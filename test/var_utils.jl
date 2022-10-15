Y = rand(20, 5)
Σu = rand(5,5)
Σu = Σu * Σu'
lags = 3
αstar = zeros(size(Y)[2]^2 * lags + size(Y)[2])
V = I(1 + size(Y)[2] * lags) * 1000.0 |> Matrix 

α, αbar = drawlagcoefficients(Y, Σu, αstar, V, lags = lags)

Sstar = I(size(Y)[2]) * 1.0 |> Matrix 
n = size(Y)[2] + 1

Σu = drawerrormatrix(Y, lags, αstar, αbar, V, Sstar, n)

obj1, obj2 =  drawparameters(Y, Σu, lags, αstar, V, Sstar, n)

N = 5
burnin = 2

αlist, Σulist = estimatevar(Y, N, burnin, lags, αstar, V, Sstar, n)