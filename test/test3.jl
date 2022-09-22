include("paths.jl")
include("path_intensity.jl")
include("ptirf.jl")
include("irf.jl")
using Plots

lagcoefmats = []
push!(lagcoefmats, [0.5 -0.25 0.3; -0.3 0.5 0.2; 0.0 0.0 0.0])
#push!(lagcoefmats, [0.1 0.03; 0.05 0.01])
#push!(lagcoefmats, [0.001 0.001; 0.001 0.0002])

shockcoefmat = [1.0 -0.2 -0.1; 0.5 1.0 -0.2; 0.5 0.5 1.0][:, :]

periods = 10
shock = 3
medium = 1
response = 1

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2)