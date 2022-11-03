function ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat) 

    A = similar(lagcoefmats) 
    for i in 1:size(A)[1]
        A[i] = copy(lagcoefmats[i])
        A[i][:,medium] = zeros(size(A[i])[1])
    end 

    responses = irf(response, shock, periods, A, shockcoefmat) 

    if shockcoefmat[shock, medium] == 0.0
        responses[1] = 0.0
        responses[2] = 0.0
    else 
        responses[1] = 0.0
    end 

    return responses 
end 