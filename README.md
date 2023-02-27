---
title: "FFR Markdown"
author: "Patrick Carr"
date: "2023-02-27"
output:
  md_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## R Markdown

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE, include = FALSE}
install.packages('pacman', repos = "http://cran.us.r-project.org")
library(pacman)
p_load(tidyverse, janitor, lubridate, sqldf, scales, ggplot, patchwork, dynlm, urca, tseries, lmtest, xts)
```

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE, include = FALSE}
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

```

As I addressed in this piece of short writing, economists have noted a relationship between a low Federal Funds Rate (FFR) and high average worker earnings in the United States. While the piece examined this trend in both the 1990’s and 2000’s, I’m only going to analyze data for the latter (in part for simplicity’s sake, and in part because the 1990’s data presents a more multifaceted picture that I believe would require some more advanced analytics to understand).

As I previously noted, the argument posited by UNC Economics professor Karl Smith is that a Federal Funds Rate that drops below the NAIRU, in this case 5%, is correlated with an increase in wages. Naturally there are numerous different factors that impact wage growth, but for now, I’ll just analyze the relationship between these two variables.

I’ll be using time series panel data to test this hypothesis; the data consists of quarterly values of the FFR and wage data from the Bureau of Labor Statistics that tracks the median usual weekly real earnings for full-time wage and salary workers over the wage of 16. While we’re primarily examining the trend post-2008, I’ve included data from 1981 to 2020 to gain a better understanding of the long-term relationship between these two variables.

First, I’ll visualize the data. I’ll create a scatterplot the effective Federal Funds Rate against my wage data:


```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
data |> 
  ggplot() +
  geom_point(aes(x = fed_rate, y = wages), size = 2.5, color = "#1d65a0") +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  xlab("Rate") + 
  ylab("Wages") +
  ggtitle("Wages vs. Federal Funds Rate") +
  theme(panel.background = element_rect(fill = 'white', color = 'black'),
        panel.grid.major = element_line(color = '#818a92', linetype = 'dotted'),
        panel.grid.minor = element_line(color = '#818a92', linetype = 'dotted'),
        axis.text.x = element_text(color = 'black', size = 11),
        axis.text.y = element_text(color = 'black', size = 11),
        axis.title.x = element_text(color = 'black', size = 12.5),
        axis.title.y = element_text(color = 'black', size = 12.5),
        plot.title = element_text(size = 14))
```

We can see just from this that higher wages tend to cluster around a lower FFR. A line graph depicting these trends over time suggests the same, with a declining FFR depicted in red above, and increasing wages depicted in blue below:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
wage_plot <- data |> ggplot() +
  geom_line(aes(x = date, y = wages), size = 1.5, color = "#3d82b5") +
  ylab("Wages") +
  ggtitle("Wage and Fed Rate Trends") +
  theme(panel.background = element_rect(fill = 'white', color = 'black'),
        panel.grid.major = element_line(color = '#818a92', linetype = 'dotted'),
        panel.grid.minor = element_line(color = '#818a92', linetype = 'dotted'),
        axis.text.y = element_text(color = 'black', size = 11),
        axis.title.y = element_text(color = 'black', size = 12.5),
        axis.title.x=element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank(),
        plot.title = element_text(size = 14, face = "bold"))

rate_plot <- data |> ggplot() +
  geom_line(aes(x = date, y = fed_rate), size = 1.5, color = "#9a4c4a") +
  xlab("Date") +
  ylab("Rate") +
  theme(panel.background = element_rect(fill = 'white', color = 'black'),
        panel.grid.major = element_line(color = '#818a92', linetype = 'dotted'),
        panel.grid.minor = element_line(color = '#818a92', linetype = 'dotted'),
        axis.text.x = element_text(color = 'black', size = 11),
        axis.text.y = element_text(color = 'black', size = 11),
        axis.title.x = element_text(color = 'black', size = 12.5),
        axis.title.y = element_text(color = 'black', size = 12.5),
        plot.title = element_text(size = 14, face = "bold"))

wage_plot + rate_plot + plot_layout(ncol=1)
```

However, we’re not simply testing whether a lower federal funds rate correlates with lower wages, but rather, whether the federal funds rate dropping below a certain value correlates with a higher rate of wage growth. If this is true, we would expect this data to be nonstationary.


We’ll run an autocorrelation test on my wage dataset to help visualize this:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
dynamic_model <- dynlm(wages ~ fed_rate, data = data)
acf(residuals(dynamic_model))
```

We can see the lags are well correlated with each other, implying nonstationarity.

Next, we’ll apply a Dickey-Fuller test:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
summary(ur.df(data$wages, type = "drift", lags = 0))
```

With a p-value of 0.4474, we cannot reject the null-hypothesis that the data is non-stationary.

Finally, we’ll apply a KPSS test:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
kpss.test(data$wages, null = "Trend")
```

With a p-value of 0.01, we can reject the null hypothesis that the data is stationary. With these three tests in mind, we can assume that the impact of the Federal Funds rate on wages is not consistent over time.

First, let’s run a dynamic regression to look at the overall trend between the FFR and wages:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
data$fed_rate <- data$fed_rate * 100
dynamic_model <- dynlm(wages ~ fed_rate, data = data)
coeftest(dynamic_model)
```

The low p-values observed in this regression imply that a 0.01 increase in the FFR corresponds to a 2.56 decrease in the wage index. However, keep in mind that this is looking at all data from 1981 to 2020.


Given the non-stationarity of the data, if Professor Smith’s argument is correct, we should see a break in the FFR coefficient for data observed once the Federal Funds Rate crosses below 5. During the 2008 recession, this occurred in the third quarter of 2007:

```{r, echo = FALSE, message = FALSE, warning = FALSE, error = FALSE}
data_subset <- data[116:176,]
subset_model <- dynlm(wages ~ fed_rate, data = data_subset)
coeftest(subset_model)
```


