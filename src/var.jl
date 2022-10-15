"""
"""
function estimatevar(Y::Matrix{Float64}, N::Int64, burnin::Int64, lags::Int64, αstar::Vector{Float64}, V::Matrix{Float64}, Sstar::Matrix{Float64}, n::Int64)

    αlist = Matrix{Float64}[]
    Σulist = Matrix{Float64}[]

    Σu = rand(size(Y)[2], size(Y)[2])
    Σu = Σu * Σu'

    for i in 1:N
        println("Iteration: $i")
        α, Σu = drawparameters(Y, Σu, lags, αstar, V, Sstar, n)
        if i > burnin
            push!(αlist, α)
            push!(Σulist, Σu)
        end
    end

    return αlist, Σulist
end 