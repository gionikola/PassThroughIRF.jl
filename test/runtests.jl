using PassThroughIRF
using Test

@testset "PassThroughIRF.jl" begin
    
    @test PassThroughIRF.allpaths(1, 1)[1][1] == 1
    @test PassThroughIRF.allpaths(2, 2)[1][2] == 2
    
end
