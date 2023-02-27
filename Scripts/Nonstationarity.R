## Nonstationarity Tests

# Autocorrelation
dynamic_model <- dynlm(wages ~ fed_rate, data = data)
acf(residuals(dynamic_model))