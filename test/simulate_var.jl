T = 10000
numvar = 2
lags = 2
coefficients = [0.0 0.5 0.01 0.1 0.0
    0.0 0.02 0.4 0.0 -0.1]
covariance = [1.0 0.2; 0.2 1.0]

data = simulatevar(T, numvar, lags, coefficients, covariance)

V = I(1 + size(data)[2] * lags) * 1000.0 |> Matrix
Sstar = I(size(data)[2]) * 1.0 |> Matrix
n = size(data)[2] + 1

N = 1000
burnin = 100

αlist, Σulist = estimatevar(data, N, burnin, lags, vec(coefficients), V, Sstar, n)