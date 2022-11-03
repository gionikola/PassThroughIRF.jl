function irf(response, shock, periods, lagcoefmats, shockcoefmat) 

    A = zeros(size(lagcoefmats)[1] * size(lagcoefmats[1])[1], size(lagcoefmats)[1] * size(lagcoefmats[1])[1])
    for i in 1:size(lagcoefmats)[1]
        A[1:size(lagcoefmats[1])[1], (1 + (i-1)*size(lagcoefmats[1])[1]):(i)*size(lagcoefmats[1])[1]] = lagcoefmats[i]
        if i < size(lagcoefmats)[1]
            A[size(lagcoefmats[1])[1] + i, i] = 1.0
        end 
    end 

    B = zeros(size(A)[2], size(shockcoefmat)[2])
    B[1:size(shockcoefmat)[1], 1:size(shockcoefmat)[2]] = shockcoefmat

    shockvec = zeros(size(B)[2])
    shockvec[shock] = 1
    responses = zeros(1 + periods)
    for t in 0:periods
        fullresponse = A^t * B * shockvec
        responses[t+1] = fullresponse[response]
    end 

    return responses
end 