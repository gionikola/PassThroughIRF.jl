using PassThroughIRF

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

A = mean(αlist)[:,2:end]
Σ = mean(Σulist)
Q = PassThroughIRF.rotationmat(Σ)

lagcoefmats = []
push!(lagcoefmats, A[1:2,1:2])
push!(lagcoefmats, A[1:2,3:4])

shockcoefmat = Q

periods = 10
shock = 2
medium = 2
response = 2

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2) 
