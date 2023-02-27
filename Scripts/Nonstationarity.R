## Nonstationarity Tests

# Autocorrelation
dynamic_model <- dynlm(wages ~ fed_rate, data = data)
acf(residuals(dynamic_model))

# Augmented Dickey-Fuller Test
summary(ur.df(data$wages, type = "drift", lags = 0))

# KPSS Test
kpss.test(data$wages, null = "Trend")