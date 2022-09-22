using PassThroughIRF
using Documenter

DocMeta.setdocmeta!(PassThroughIRF, :DocTestSetup, :(using PassThroughIRF); recursive=true)

makedocs(;
    modules=[PassThroughIRF],
    authors="gionikola",
    repo="https://github.com/gionikola/PassThroughIRF.jl/blob/{commit}{path}#{line}",
    sitename="PassThroughIRF.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gionikola.github.io/PassThroughIRF.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/gionikola/PassThroughIRF.jl",
    devbranch="main",
)
