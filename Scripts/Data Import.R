# Import Federal Funds Rate Data
ffr <- read_csv("Raw Data/FEDFUNDS.csv",
                col_names = c("date", "fed_rate"), skip = 1)
ffr$fed_rate <- as.numeric(ffr$fed_rate / 100)


# Import Wage Data
wages <- read_csv("Raw Data/LES1252881600Q.csv",
                  col_names = c("date", "wages"), skip = 1)

data <- sqldf (
  "select w.date, w.wages, f.fed_rate from wages w
  left join ffr f on w.date = f.date"
)

view(data)