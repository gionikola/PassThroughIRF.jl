using PassThroughIRF
using Test

@testset "PassThroughIRF.jl" begin
    
    @test allpaths(1, 1)[1][1] == 1
    @test allpaths(2, 2)[1][1] == 2
    
end
