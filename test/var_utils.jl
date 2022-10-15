Y = rand(20, 5)
Σ = rand(5,5)
Σ = Σ * Σ'
lags = 3
priormean = zeros(size(Y)[2]^2 * lags + size(Y)[2])
priorvar = I(length(priormean)) * 1000.0 |> Matrix

α = drawlagcoefficients(Y, Σ, priormean, priorvar, lags = lags)