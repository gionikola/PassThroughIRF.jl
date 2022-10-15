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
function drawlagcoefficients(Y::Matrix{Float64}, Σ::Matrix{Float64}, priormean::Vector{Float64}, priorvar::Matrix{Float64}; lags::Int64 = 1)
    
    if length(priormean) != size(Y)[2]^2 * lags + size(Y)[2] 
        throw("`priormean` must be equal to M^2 * p + M, where M is the number of endogenous variables and p is the number of lags.")
    end 

    if size(priorvar)[1] != length(priormean)  
        throw("`priorvar` must be a square matrix of the same length/width as the length of vector `priormean`.")
    end 

    if isposdef(priorvar) != true 
        throw("`priorvar` must be a positive definite matrix (which implies it must be Hermitian).")
    end 
    
    p = lags 
    y = vec(Y[(p+1):end,:]')
    T = size(Y)[1]
    Z = zeros(T - p, 1 + p * size(Y)[2])
    for i in p:(T-1) 
        Z[i-p+1,:] = vcat([1], vec(Y[(i-p+1):i,:]'))
    end 
    Z = Z' 
    w = [ sqrt(inv(priorvar)) * priormean ; kron(I(T-p), sqrt(inv(Σ))) * y ] 
    W = [ sqrt(inv(priorvar)) ; kron(Z', sqrt(inv(Σ))) ]
    Σbar = inv(W' * W)
    αbar = Σbar * W' * w 

    return α = multinormal(αbar, Σbar)
end 