using PassThroughIRF
using LinearAlgebra
using Statistics
using Plots

T = 200
numvar = 2
lags = 1
coefficients = [0.0 0.5 0.01
    0.0 0.02 0.4]
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

lagcoefmats = Matrix{Float64}[]
push!(lagcoefmats, A[1:2,1:2])
#push!(lagcoefmats, A[1:2,3:4])

shockcoefmat = Q

periods = 10
shock = 2
medium = 1
response = 2

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2) 

###############
###############
###############
periods = 10
shock = 1
medium = 2
response = 1

Qlist = Matrix{Float64}[] 
irflist = Vector{Float64}[] 
ptirflist = Vector{Float64}[] 
for i in 1:length(αlist)
    println(i)
    Q = PassThroughIRF.rotationmat(Σulist[i])
    push!(Qlist, Q)
    shockcoefmat = Q 
    lagcoefmats = Matrix{Float64}[]
    push!(lagcoefmats, αlist[i][:,2:end])
    res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
    res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)
    push!(irflist, res1)
    push!(ptirflist, res2)
end 

irfdistr = zeros(periods-1, 3)
for i in 1:(periods-1)
    responses = zeros(length(αlist))
    for j in 1:length(αlist)
        responses[j] = irflist[j][i]
    end  
    irfdistr[i,1] = mean(responses) 
    irfdistr[i,2] = quantile(responses, 0.1)
    irfdistr[i,3] = quantile(responses, 0.9)
end 
plot(irfdistr) 

irfdistr = zeros(periods-1, 3)
for i in 1:(periods-1)
    responses = zeros(length(αlist))
    for j in 1:length(αlist)
        responses[j] = ptirflist[j][i]
    end  
    irfdistr[i,1] = mean(responses) 
    irfdistr[i,2] = quantile(responses, 0.1)
    irfdistr[i,3] = quantile(responses, 0.9)
end 
plot(irfdistr) 
