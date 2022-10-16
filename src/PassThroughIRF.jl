module PassThroughIRF

    using LinearAlgebra
    using Statistics 
    using Random

    include("paths.jl")
    include("path_intensity.jl")
    include("irf.jl")
    include("ptirf.jl")
    include("var_utils.jl")
    include("simulate_var.jl")
    include("var.jl")

    export irf, ptirf, simulatevar, estimatevar

end