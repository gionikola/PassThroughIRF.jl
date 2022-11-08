using PassThroughIRF
using LinearAlgebra
using Statistics
using CSV
using DataFrames
using ShiftedArrays
using Plots

data = CSV.read("analysis/data/data_v2.csv", DataFrame)
data = [data.TOTCI_PCH data.GDPC1_PCH data.MEDCPIM158SFRBCLE data.BRW./std(data.BRW)]
#data = CSV.read("analysis/data/data.csv", DataFrame)
#data = [data.TOTCI_PCH data.GDPC1_PCH data.MEDCPIM158SFRBCLE data.FF]
data = data[1:(end-4), :]

lags = 12
V = I(1 + size(data)[2] * lags) * 100.0 |> Matrix
Sstar = I(size(data)[2]) * 1.0 |> Matrix
n = size(data)[2] + 1

N = 5_000
burnin = 2_000

αlist, Σulist = estimatevar(data, N, burnin, lags, zeros(size(data)[2]^2 * lags + size(data)[2]), V, Sstar, n)

A = mean(αlist)[:, 2:end]
Σ = mean(Σulist)
Q = PassThroughIRF.rotationmat(Σ)

lagcoefmats = Matrix{Float64}[]
push!(lagcoefmats, A[:, 1:4])
push!(lagcoefmats, A[:, 5:8])
push!(lagcoefmats, A[:, 9:12])
push!(lagcoefmats, A[:, 13:16])
push!(lagcoefmats, A[:, 17:20])
push!(lagcoefmats, A[:, 21:24])
push!(lagcoefmats, A[:, 25:28])
push!(lagcoefmats, A[:, 29:32])
push!(lagcoefmats, A[:, 33:36])
push!(lagcoefmats, A[:, 37:40])
push!(lagcoefmats, A[:, 41:44])
push!(lagcoefmats, A[:, 45:48])

shockcoefmat = Q

periods = 20
shock = 4
medium = 1
response = 2

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

yi = response
ek = shock
h = periods

quants = zeros(length(αlist), h + 1)
for i in 1:length(αlist)
    Qi = PassThroughIRF.rotationmat(Σulist[i])
    Ai = αlist[i][:, 2:end]
    lagcoefmatsi = Matrix{Float64}[]
    push!(lagcoefmatsi, Ai[:, 1:4])
    push!(lagcoefmatsi, Ai[:, 5:8])
    push!(lagcoefmatsi, Ai[:, 9:12])
    push!(lagcoefmatsi, Ai[:, 13:16])
    push!(lagcoefmatsi, Ai[:, 17:20])
    push!(lagcoefmatsi, Ai[:, 21:24])
    push!(lagcoefmatsi, Ai[:, 25:28])
    push!(lagcoefmatsi, Ai[:, 29:32])
    quants[i, :] = irf(yi, ek, h, lagcoefmatsi, Qi)
end
res_bottom = zeros(h)
res_top = zeros(h)
for i in 1:h
    res_bottom[i] = quantile(quants[:, i], 0.1)
    res_top[i] = quantile(quants[:, i], 0.9)
end

plot(res1)
plot!(res_bottom)
plot!(res_top)

plot(res1)
plot!(res2)

function cumirf(v::Vector)

    V = zeros(length(v))

    for i in 1:length(v)
        V[i] = sum(v[1:i])
    end

    return V
end

res1cum = cumirf(res1)
res2cum = cumirf(res2)

theme(:dao)
plot(res1cum, label="IRF")
plot!(res2cum, label="PT-IRF", legend=:bottomright)
xlabel!("Horizon")
ylabel!("GDP (Growth Rate)")
savefig("analysis/plots/irf_vs_ptirf.png")

####
####
####

Qlist = PassThroughIRF.rotationmat.(Σulist)
irfs = irfs(response, shock, periods, lagcoefmats, Qlist)

irflist = Vector{Float64}[]
ptirflist = Vector{Float64}[]

for i in 1:length(Qlist)
    println(i)
    push!(res1list, irf(response, shock, periods, lagcoefmats, Qlist[i]))
    push!(res2list, ptirf(response, medium, shock, periods, lagcoefmats, Qlist[i]))
end
