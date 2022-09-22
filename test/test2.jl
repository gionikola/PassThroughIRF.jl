include("paths.jl")
include("path_intensity.jl")
include("ptirf.jl")
include("irf.jl")
using Plots

lagcoefmats = []
push!(lagcoefmats, [0.5 -0.25 0.3; -0.1 0.25 0.8; 0.5 0.3 -0.1])
#push!(lagcoefmats, [0.1 0.03; 0.05 0.01])
#push!(lagcoefmats, [0.001 0.001; 0.001 0.0002])

shockcoefmat = [0.5 1.0 0.05; 0.5 1.0 3; 10.0 0.1 0.002][:, :]

periods = 10
shock = 2
medium = 3
response = 3

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2)