"""
"""
function rotationmat(A::Matrix{Float64})

    Q = cholesky(A).L |> Matrix 

    return Q::Matrix{Float64} 
end 


"""
"""
function multinormal(μ::Vector{Float64}, Σ::Matrix{Float64})

    nvar = size(Σ)[1]         # Num. of variables 

    if (0 in diag(Σ)) == false  # No degenerate random vars.
        Q = cholesky(Hermitian(Σ), Val(true), check=false).U       # Upper triang. Cholesky mat.  
        X = Q * randn(length(μ)) + μ    # Multiv. normal vector draw  
    else                        # in case of degenerate random vars.
        keep = Any[]
        for i in 1:nvar
            if Σ[i, i] != 0
                push!(keep, i)
            end
        end
        Σsub = Σ[keep, keep]
        μsub = μ[keep]
        Q = cholesky(Hermitian(Σsub), Val(true), check=false).U       # Upper triang. Cholesky mat.  
        Xsub = Q * randn(length(μsub)) + μsub    # Multiv. normal vector draw  
        X = zeros(nvar)
        j = 1
        for i in 1:nvar
            if i in keep    # If i-th var. is non-degen. 
                X[i] = Xsub[j]
                j = j + 1
            else
                X[i] = μ[i] # If i-th var. is degen. 
            end
        end
    end

    return X::Vector{Float64}
end

"""
"""
function wishart(Σ::Matrix{Float64}, n::Int64)
    Ω = zeros(size(Σ)[1], size(Σ)[1])
    for i in 1:n
        x = multinormal(zeros(size(Σ)[1]), Σ)
        Ω += x * x'
    end
    return Ω::Matrix{Float64} 
end 

"""
"""
function inversewishart(Σ::Matrix{Float64}, n::Int64)
    Ω = wishart(Σ, n)
    return inv(Ω)::Matrix{Float64}
end 

""" 
""" 
function drawlagcoefficients(Y::Matrix{Float64}, Σu::Matrix{Float64}, αstar::Vector{Float64}, V::Matrix{Float64}; lags::Int64 = 1)
    
    if length(αstar) != size(Y)[2]^2 * lags + size(Y)[2] 
        throw("`αstar` must be equal to M^2 * p + M, where M is the number of endogenous variables and p is the number of lags.")
    end 

    if size(V)[1] != 1 + size(Y)[2] * lags   
        throw("`V` must be a square matrix of the same length/width as the number of coefficient parameters in each equation of the VAR.")
    end 

    priorvar = kron(V, Σu)
    
    p = lags 
    y = vec(Y[(p+1):end,:]')
    T = size(Y)[1]
    Z = zeros(T - p, 1 + p * size(Y)[2])
    for i in p:(T-1) 
        Z[i-p+1,:] = vcat([1], vec(Y[(i-p+1):i,:]'))
    end 
    Z = Z' 
    w = [ sqrt(inv(priorvar)) * αstar ; kron(I(T-p), sqrt(inv(Σu))) * y ] 
    W = [ sqrt(inv(priorvar)) ; kron(Z', sqrt(inv(Σu))) ]
    Σbar = inv(W' * W)
    αbar = Σbar * W' * w 

    α = multinormal(αbar, Σbar)

    return α, αbar
end 

"""
"""
function drawerrormatrix(Y::Matrix{Float64}, p::Int64, αstar::Vector{Float64}, αbar::Vector{Float64}, V::Matrix{Float64}, Sstar::Matrix{Float64}, n::Int64)

    p = lags 
    T = size(Y)[1]
    Z = zeros(T - p, 1 + p * size(Y)[2])
    for i in p:(T-1) 
        Z[i-p+1,:] = vcat([1], vec(Y[(i-p+1):i,:]'))
    end 
    Z = Z' 
    Y = Y[(p+1):end,:]
    T = T - p

    Astar = reshape(αstar, size(Y)[2], 1 + size(Y)[2]*p) # αstar is prior mean for α
    Abar = reshape(αbar, size(Y)[2], 1 + size(Y)[2]*p) # αbar is posterior mean for α
    Y = Y'
    Ahat = Y * Z' * inv(Z * Z')
    Σutilde = (Y - Ahat * Z) * (Y - Ahat * Z)' * (1/T)

    S = T * Σutilde + Sstar + Ahat * Z * Z' * Ahat' + Astar * inv(V) * Astar' - Abar * (inv(V) + Z * Z') * Abar' 
    τ = T + n

    Σu = inversewishart(S, τ)

    return Σu::Matrix{Float64} 
end

"""
"""
function drawparameters(Y::Matrix{Float64}, Σu::Matrix{Float64}, lags::Int64, αstar::Vector{Float64}, V::Matrix{Float64}, Sstar::Matrix{Float64}, n::Int64)

    α, αbar = drawlagcoefficients(Y, Σu, αstar, V, lags = lags)
    Σu = drawerrormatrix(Y, lags, αstar, αbar, V, Sstar, n)
    α = reshape(α, size(Y)[2], 1 + lags * size(Y)[2])

    return α::Matrix{Float64}, Σu::Matrix{Float64} 
end 