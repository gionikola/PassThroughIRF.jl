function ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat) 

    A = similar(lagcoefmats) 
    for i in 1:size(A)[1]
        A[i] = copy(lagcoefmats[i])
        A[i][:,medium] = zeros(size(A[i])[1])
    end 

    responses = irf(response, shock, periods, A, shockcoefmat) 
    responses[1] = 0.0
    return responses 
end 