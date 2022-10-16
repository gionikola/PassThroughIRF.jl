T = 500
numvar = 2
lags = 2
coefficients = [0.0 0.5 0.01 0.1 0.0
    0.0 0.02 0.4 0.0 -0.1]
covariance = [1.0 0.2; 0.2 1.0]

data = simulatevar(T, numvar, lags, coefficients, covariance)

V = I(1 + size(data)[2] * lags) * 1000.0 |> Matrix
Sstar = I(size(data)[2]) * 1.0 |> Matrix
n = size(data)[2] + 1

N = 5000
burnin = 1000

αlist, Σulist = estimatevar(data, N, burnin, lags, vec(coefficients), V, Sstar, n)

testvec = zeros(N - burnin)
for i in 1:(N-burnin)
    testvec[i] = αlist[i][1,2]
end 

plot(testvec)