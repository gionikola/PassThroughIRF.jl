"""
"""
function simulatevar(T::Int64, numvar::Int64, lags::Int64, coefficients::Matrix{Float64}, covariance::Matrix{Float64})

    M = numvar * lags 

    interceptvec = zeros(M)
    interceptvec[1:numvar] = coefficients[:,1]

    companionmat = zeros(M, M)
    companionmat[1:numvar, :] = coefficients[:, 2:end] 
    companionmat[(numvar+1):end,1:(numvar*(lags-1))] = I(numvar*(lags-1)) * 1.0

    covmat = zeros(M, M)
    covmat[1:numvar, 1:numvar] = covariance 

    datamat = zeros(T, M)
    datamat[1,:] = inv(I(M) - companionmat) * interceptvec 

    for t in 2:T 
        datamat[t,:] = interceptvec + companionmat * vec(datamat[t-1,:]) + multinormal(zeros(M), covmat)
    end 

    return datamat[:,1:numvar] 
end 