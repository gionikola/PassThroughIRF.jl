function pathintensity(path, lagcoefmat, shockcoefmat, shocknum)
    
    shockcoefvec = shockcoefmat[:,shocknum]
    intensity = shockcoefvec[path[1]]
    for i in 2:length(path) 
        intensity *= lagcoefmat[path[i], path[i-1]] 
    end 
    
    return intensity 
end 