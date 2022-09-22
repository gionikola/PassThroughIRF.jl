using PassThroughIRF
using Test

@testset "PassThroughIRF.jl" begin

    @test PassThroughIRF.allpaths(1, 1)[1][1] == 1
    @test PassThroughIRF.allpaths(2, 2)[1][2] == 2

    lagcoefmats = []
    push!(lagcoefmats, [0.5 0.25; 0.25 0.8])
    push!(lagcoefmats, [0.1 0.03; 0.05 0.01])
    push!(lagcoefmats, [0.001 0.001; 0.001 0.0002])

    shockcoefmat = [0.5 1.0; 0.5 2.0][:, :]

    periods = 15
    shock = 1
    medium = 2
    response = 2

    res1 = irf(response, shock, periods, lagcoefmats, shockcoefmat)
    res2 = ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat)

    @test res1[1] == 0.525
    @test res2[1] == 0.4

end
