function ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat) 

    for i in 1:size(lagcoefmats)[1]
        lagcoefmats[i][:,medium] = zeros(size(lagcoefmats[i])[1])
    end 

    return irf(response, shock, periods, lagcoefmats, shockcoefmat) 
end 