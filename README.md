# Recreation-of-Minard-Map
Minard Map depicts the advance into (1812) and retreat from (1813) Russia by Napoleon’s Grande Armée, which was decimated by a combination of the Russian winter, the Russian army and its scorched-earth tactics.

Summary of what's in this project and how it was built:

• Implemented using Rstudio mainly ggplot2 library and Dplyr package. 
• Extracted the excel file that contained the minard data and converted it into a R data frame. 
• Extracted the first 5 columns, next 3 columns and the last 5 columns separately in order to plot the required graph.  
• Used ggplot(),  geom_path(), geom_point() and geom_text() functions namely to plot the graph between longitude v/s latitude depicting the position of cities and path of army through them and also survivors in the army along the path.
• Used the ggmap() library along with the get_stamenmap() to get the exact map for the location of the cities.  
• get_stamenmap() gets the exact map using Google API therefore, I have created two maps one with water colour map as the background and the other with terrain map as the background.
• Plotted the graph of longitude v/s temperature using ggplot(). 
• Used gridExtra() and gtable() library to plot both the plots that is the one representing cities and the one representing temperature on the same plot. 
• Converted the combined graph using ggplotGrob() in order to align the axis of both the graphs. 
• Final graph represents longitude on the x-axis along with two y-axis one of the y-axis is latitude in order to depict the cities and the path travelled and the other y-axis is depicting temperature.
