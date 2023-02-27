##Data Visualizations

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
