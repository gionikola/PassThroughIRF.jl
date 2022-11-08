using Plots
using PassThroughIRF
using LinearAlgebra
using Random
using Statistics

T = 400
numvar = 2
lags = 2
coefficients = [0.0 0.5 0.2 0.1 0.0
    0.0 0.8 0.4 0.3 -0.1]
covariance = [1.0 0.0; 0.0 1.0]

data = simulatevar(T, numvar, lags, coefficients, covariance)

V = I(1 + size(data)[2] * lags) * 1000.0 |> Matrix
Sstar = I(size(data)[2]) * 1.0 |> Matrix
n = size(data)[2] + 1

N = 5000
burnin = 1000

αlist, Σulist = estimatevar(data, N, burnin, lags, vec(coefficients), V, Sstar, n)

A = mean(αlist)[:, 2:end]
Σ = mean(Σulist)
Q = PassThroughIRF.rotationmat(Σ)

lagcoefmats = Matrix{Float64}[]
push!(lagcoefmats, A[:, 1:2])
push!(lagcoefmats, A[:, 3:4])

actualcoefmats = Matrix{Float64}[]
push!(actualcoefmats, coefficients[:, 2:3])
push!(actualcoefmats, coefficients[:, 4:5])

yi = 2
ek = 1
h = 25

res1 = irf(yi, ek, h, actualcoefmats, [1.0 0.0; 0.0 1.0])
res2 = irf(yi, ek, h, lagcoefmats, Q)

quants = zeros(length(αlist), h+1)
for i in 1:length(αlist)
    Qi = PassThroughIRF.rotationmat(Σulist[i])
    Ai = αlist[i][:, 2:end]
    lagcoefmatsi = Matrix{Float64}[]
    push!(lagcoefmatsi, Ai[:, 1:2])
    push!(lagcoefmatsi, Ai[:, 3:4])
    quants[i, :] = irf(yi, ek, h, lagcoefmatsi, Qi)
end 
res_bottom = zeros(h)
res_top = zeros(h)
for i in 1:h
    res_bottom[i] = quantile(quants[:, i], 0.1)
    res_top[i] = quantile(quants[:, i], 0.9)
end 

plot(res1)
plot!(res2)
plot!(res_bottom)
plot!(res_top)