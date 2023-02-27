## Line Graph Comparisons ##

wage_plot <- data |> ggplot() +
  geom_line(aes(x = date, y = wages), size = 1.5, color = "#3d82b5") +
  ylab("Wages") +
  ggtitle("Wage Title") +
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