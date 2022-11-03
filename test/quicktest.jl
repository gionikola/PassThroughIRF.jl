using Plots
using PassThroughIRF

lagcoefmats = []
push!(lagcoefmats, [0.5 -0.25 0.3; -0.3 0.5 0.2; 0.0 0.0 0.0])
push!(lagcoefmats, [0.1 0.03 0.3; 0.05 0.01 0.2; 0.01 .05 0.03])
push!(lagcoefmats, [0.001 0.001 2.0; 0.001 0.0002 0.5; 0.5 0.1 0.01])

shockcoefmat = [1.0 -0.0 -0.0; 0.5 1.0 -0.0; 0.5 0.5 1.0][:, :]

periods = 20
shock = 1
medium = 3
response = 3

res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

plot(res1)
plot!(res2)