## T Tests ##

# Initial Test
data$fed_rate <- data$fed_rate * 100
dynamic_model <- dynlm(wages ~ fed_rate, data = data)
coeftest(dynamic_model)


# Subset Model
data_subset <- data[116:176,]
subset_model <- dynlm(wages ~ fed_rate, data = data_subset)
coeftest(subset_model)