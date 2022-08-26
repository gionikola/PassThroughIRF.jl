function irf(response, shock, periods, lagcoefmats, shockcoefmat) 

    numvars = size(shockcoefmat)[1]
    var_indexes = 1:numvars 
    numlags = length(lagcoefmats)
    
    paths = []
    for t in 1:periods 
        paths_t = allpaths(var_indexes, t)
        storepaths_t = []
        for i in 1:length(paths_t)
            if paths_t[i][end] == response
                push!(storepaths_t, paths_t[i]) 
            end 
        end 
        push!(paths, storepaths_t)
    end 

    response = []
    for t in 2:(length(paths))
        response_t = []
        if t <= numlags 
            for j in 0:(t-2)
                for i in 1:length(paths[t-j])
                    push!(response_t, pathintensity(paths[t-j][i], lagcoefmats[j+1], shockcoefmat, shock))
                end 
            end 
        else 
            for j in 0:(numlags-1)
                for i in 1:length(paths[t-j])
                    push!(response_t, pathintensity(paths[t-j][i], lagcoefmats[j+1], shockcoefmat, shock))
                end 
            end 
        end 
        push!(response, sum(response_t)) 
    end 

    return response
end 