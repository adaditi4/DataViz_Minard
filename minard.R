install.packages("XLConnect", dependencies=TRUE)
install.packages("ggrepel", dependencies=TRUE)
install.packages("ggplot2", dependencies=TRUE)

library(XLConnect)
library(ggplot2)
library(ggrepel)
library(scales)
library(grid)
library(gridExtra)
library(dplyr)

#load dataset
data <- loadWorkbook("E:/Trinity/SEM 2/DataViz/Assignment2/Minards/minard-data.xlsx")
cities <- readWorksheet(data, sheet = "Sheet1",startCol=1,endCol=3)
temps <- readWorksheet(data, sheet = "Sheet1",startCol=4,endCol=8)
troops <- readWorksheet(data, sheet = "Sheet1",startCol=9,endCol=13)
str(cities)
str(temps)
str(troops)

#CITIES
ggplot() +
  geom_path(data = troops, aes(x = LONP, y = LATP, group = DIV, 
                               color = DIR, size = SURV),
            lineend = "round") +
  geom_point(data = cities, aes(x = LONC, y = LATC),
             color = "#DC5B44") +
  geom_text_repel(data = cities, aes(x = LONC, y = LATC, label = CITY),
                  color = "#DC5B44", family = "Open Sans Condensed Bold") +
  scale_size(range = c(0.5, 15)) + 
  scale_colour_manual(values = c("#DFC17E", "#252523")) +
  labs(x = NULL, y = NULL) + 
  guides(color = FALSE, size = FALSE)
plot_troops_cities <- last_plot()



#temperature
ggplot(temps, aes(LONT, TEMP)) + geom_path(color="grey", size=1.5) + geom_point(size=2)
temps <- temps %>% mutate(label = paste0(TEMP, "° ", MON, DAY))
head(temps$label)

ggplot(temps, aes(LONT, TEMP)) + geom_path(color="grey", size=1.5) + geom_point(size=1) + geom_text(aes(label=label), size=2, vjust=-1)


ggplot(temps, aes(LONT, TEMP)) +
  geom_path(color="grey", size=1.5) +
  geom_point(size=1) +
  geom_text_repel(aes(label=label), size=2.5)

plot_temp <- last_plot()

grid.arrange(plot_troops_cities, plot_temp)

plot_troops_cities_fixed <- plot_troops_cities

plot_temp +
  coord_cartesian(xlim = c(24, 38)) +
  labs(x = NULL, y="Temperature") +
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())

plot_temp_fixed <- last_plot()

grid.arrange(plot_troops_cities_fixed, plot_temp_fixed, nrow=2, heights=c(3.5, 1.2))
grid.rect(width = .99, height = .99, gp = gpar(lwd = 2, col = "BLUE", fill = NA))