using PassThroughIRF
using LinearAlgebra
using Statistics
using CSV
using DataFrames
using Plots

data = CSV.read("analysis/data/data.csv", DataFrame)
data = [data.TOTCI_PCH data.GDPC1_PCH data.MEDCPIM158SFRBCLE data.FF]

lags = 8
V = I(1 + size(data)[2] * lags) * 1000.0 |> Matrix
Sstar = I(size(data)[2]) * 1.0 |> Matrix
n = size(data)[2] + 1

N = 2000
burnin = 500

αlist, Σulist = estimatevar(data, N, burnin, lags, zeros(size(data)[2]^2 * lags + size(data)[2]), V, Sstar, n)

A = mean(αlist)[:,2:end]
Σ = mean(Σulist)
Q = PassThroughIRF.rotationmat(Σ)

lagcoefmats = Matrix{Float64}[]
push!(lagcoefmats, A[:,1:4])
push!(lagcoefmats, A[:,5:8])
push!(lagcoefmats, A[:,9:12])
#push!(lagcoefmats, A[1:2,3:4])

shockcoefmat = Q

periods = 10
shock = 4
medium = 1
response = 2

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2) 