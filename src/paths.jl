
allpaths(var_indexes, period) = collect(Iterators.product(ntuple(i->var_indexes, period)...))

function filterpaths(response::Int, medium::Int, numvars::Int, periods::Int)
    
    var_indexes = 1:numvars
    
    paths = []
    for t in 1:periods 
        paths_t = allpaths(var_indexes, t)
        storepaths_t = []
        for i in 1:length(paths_t)
            if medium in paths_t[i][2:(end-1)] && paths_t[i][end] == response
                push!(storepaths_t, paths_t[i]) 
            end 
        end 
        if size(storepaths_t) == (0,)
            push!(paths, "empty")
        else  
            push!(paths, storepaths_t)
        end 
    end 

    return paths 
end 