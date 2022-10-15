"""
"""
function simulatevar(T::Int64, numvar::Int64, lags::Int64, coefficients::Matrix{Float64}, covariance::Matrix{Float64})

    interceptvec = zeros(numvar*lags)
    interceptvec[1:numvar] = coefficients[:,1]

    companionmat = zeros(numvar*lags, numvar*lags)
    companionmat[1:numvar, :] = coefficients[:, 2:end] 
    companionmat[(numvar+1):end,1:(numvar*(lags-1))] = I(numvar*(lags-1)) * 1.0

    covmat = zeros(numvar*lags, numvar*lags)
    covmat[1:numvar, 1:numvar] = covariance 

    datamat = zeros(T, numvar*lags)
    datamat[1,:] = inv(I(numvar*lags) - companionmat) * interceptvec 

    for t in 2:T 
        datamat[t,:] = interceptvec + companionmat * vec(datamat[t-1,:]) + multinormal(zeros(numvar*lags), covmat)
    end 

    return datamat[:,1:numvar] 
end 