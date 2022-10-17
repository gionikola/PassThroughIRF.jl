function ptirf(response, medium, shock, periods, lagcoefmats, shockcoefmat) 

    numvars = size(shockcoefmat)[1]
    numlags = length(lagcoefmats)
    paths = filterpaths(response, medium, numvars, periods)
    responsevarnum = response 
    response = []
    #push!(response, shockcoefmat[responsevarnum, shock])
    for t in 2:(length(paths))
        response_t = []
        if t <= numlags 
            for j in 0:(t-2)
                if paths[t-j] == "empty"
                    push!(response_t, 0.0)
                else 
                    for i in 1:length(paths[t-j])
                        push!(response_t, pathintensity(paths[t-j][i], lagcoefmats[j+1], shockcoefmat, shock))
                    end 
                end 
            end 
        else 
            for j in 0:(numlags-1)
                if paths[t-j] == "empty"
                    push!(response_t, 0.0)
                else 
                    for i in 1:length(paths[t-j])
                        push!(response_t, pathintensity(paths[t-j][i], lagcoefmats[j+1], shockcoefmat, shock))
                    end 
                end 
            end 
        end 
        push!(response, sum(response_t)) 
    end 

    return response
end 