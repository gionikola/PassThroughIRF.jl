T = 10000
numvar = 2
lags = 2
coefficients = [0.0 0.5 0.01 0.1 0.0; 
                0.0 0.02 0.4 0.0 -0.1]
covariance = [1.0 0.2; 0.2 1.0]

data = simulatevar(T, numvar, lags, coefficients, covariance)