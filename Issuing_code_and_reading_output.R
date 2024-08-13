library(tidyverse)
library(ggplot2)
library(patchwork)

theme_set(theme_minimal()) # Sets the theme of EVERY plot to theme minimal

getwd() # Basically the R equivalent of pwd

setwd('../r_bridge/code') # Basically brings you up one working directory
# This will be different from the terminal; on terminal, you'll still be somewhere else
# But the console (and this code) will recognize your wd as whatever you set it to

list.files() # Basically the R equivalent of ls

ss <- read.csv('squirrels_subset.csv')

rm(mod) # removes the mod object from the memory
rm(d) # removes the d object from the memory

ls() # lists what's in your working memory (Environment on the right)

head(ss) # Gives me the first couple lines of data to work with

dim(ss) # Gives me rows, then columns (assuming 2D)

# 2.2.5 aes(x= , y=) with squirrels
squirrel_subset <- read.csv('squirrels_subset.csv')

ggplot(data = squirrel_subset) + # Btw, normally we break the line after a "+"
  aes(x = long) +
  aes(y = lat)
# Alternatively, to make it easier to read:
ggplot(data = squirrel_subset) + 
  aes(x = long, y = lat)

# Time to use a bunch of geom_point for scatterplot stuff
ggplot(data = squirrel_subset) + 
  aes(x = long, y = lat) +
  geom_point() # Usually goes last
# You can also put everything into geom_point as well:
ggplot() +
  geom_point(data = squirrel_subset, aes(x = long, y = lat))
# However, it doesn't make as much sense as the first method

# Adding more stuff:
ggplot(data = squirrel_subset) + 
  aes(x = long, y = lat, color = primary_fur_color) +
  geom_point()


# 3.1.5 geom_bar() and geom_col()
# Forward pipe operator - takes the output of the expression on its left and
# passes it as the first argument to the function on its right
squirrel_subset_by_color <- squirrel_subset %>%
  group_by(primary_fur_color) %>%
  summarise(count_by_color = n()) # Summarizes the data by the count (n() is
# number of observations that occur for each of the groups), and assigns it
# to the variable (count_by_color)

plot_col <- squirrel_subset_by_color %>% # With the squirrel_subset_by_color, do the following:
  ggplot() +
  aes(x = primary_fur_color, y = count_by_color) +
  geom_col()

# Using by geom_bar() instead
plot_bar <- squirrel_subset %>%
  ggplot() +
  aes(x = primary_fur_color) +
  geom_bar()
# Basically, geom_bar() automatically has a summarizing feature built into it


# 3.1.8 geom_*()
squirrel_subset %>%
  ggplot() +
  aes(x = long) +
  geom_histogram()

squirrel_subset %>%
  ggplot() +
  aes(x = long) +
  geom_density()

# 3.2.2 Grouping in a Single Plot
squirrel_subset %>%
  ggplot() +
  aes(x = long) +
  geom_histogram() +
  facet_wrap(vars(primary_fur_color)) # facet_wrap is a bit of an older function,
#   so we need to wrap the actual columns (variables) in "vars()" so facet_wrap can
#   actually see that they are variables
# facet_wrap itself wraps a 1d sequence of panels into 2d

# If instead you want just one column, you add "ncol = 1" to facet_wrap
squirrel_subset %>%
  ggplot() +
  aes(x = long) +
  geom_histogram() +
  facet_wrap(vars(primary_fur_color), ncol = 1) 

# Grouping in Multiple Plots
# Showing the total number of squirrels broken down by color (not relative levels)
squirrel_subset %>%
  ggplot() +
  aes(x = long, fill = primary_fur_color) +
  geom_histogram()

# Showing the total number of squirrels, but separated from relative showing
squirrel_subset %>%
  ggplot() +
  aes(x = long, fill = primary_fur_color) +
  geom_histogram(position = 'dodge')


# 3.3.2 Summarising Data Using "stat_"
squirrel_subset_by_color_2 <- squirrel_subset %>%
  group_by(date_f, primary_fur_color) %>%
  summarise(count_of_squirrels = n())

squirrel_subset_by_color_2 %>%
  ggplot() +
  aes(x = date_f, y = count_of_squirrels, color = primary_fur_color) +
  geom_line() + # If you comment out "geom_line(), you just get the stat_smooth line
  stat_smooth(se = FALSE) # Gets an average curve, and set the Standard Error to FALSE


# 3.3.5 Titling and Labeling Using labs()
squirrel_subset_by_color_2 %>%
  ggplot() +
  aes(x = date_f, y = count_of_squirrels, color = primary_fur_color) +
  #geom_line() + 
  stat_smooth(se = FALSE, span = 0.8) +
  labs( # Modifying labels and legend
    title = 'Decreasing Count of Squirrels Through Time',
    subtitle = 'Moving average smoother estimate',
    x = 'Date of Observation',
    y = 'Count of Squirrels',
    color = 'Primary Fur Color' # Modify legend by changing the variable of legend
  )

# 3.3.8 Controlling the Plot Extents Using lims() and coord_cartesian()
# Using coord_cartesian
ss_plot_coord_cartesian <- squirrel_subset_by_color_2 %>%
  ggplot() +
  aes(x = date_f, y = count_of_squirrels, color = primary_fur_color) +
  stat_smooth(se = FALSE, span = 0.8) +
  labs(
    title = 'Decreasing Count of Squirrels Through Time',
    subtitle = 'Moving average smoother estimate',
    x = 'Date of Observation',
    y = 'Count of Squirrels',
    color = 'Primary Fur Color'
  ) +
  coord_cartesian( # The full data is feeding here, but I'm limiting the coordinate
    # system to only what I want to show
    xlim = c(as.Date.character('2018-10-08'),
             as.Date.character('2018-10-15')),
    ylim = c(-10,110)
  )

# Using lims()
ss_plot_lims <- squirrel_subset_by_color_2 %>%
  ggplot() +
  aes(x = date_f, y = count_of_squirrels, color = primary_fur_color) +
  stat_smooth(se = FALSE, span = 0.8) +
  labs(
    title = 'Decreasing Count of Squirrels Through Time',
    subtitle = 'Moving average smoother estimate',
    x = 'Date of Observation',
    y = 'Count of Squirrels',
    color = 'Primary Fur Color'
  ) +
  lims( # Limits the data to only that from 10/8/2018 to 10/15/2018
    x = c(as.Date.character('2018-10-08'),
             as.Date.character('2018-10-15'))
  )

# Plotting side by side
ss_plot_coord_cartesian | ss_plot_lims
# You can see above that the graphs look wildly different, since lims literally
# limited the data that was being put into the graph


# 3.3.11 Setting the Theme
squirrel_subset_by_color_2 %>%
  ggplot() +
  aes(x = date_f, y = count_of_squirrels, color = primary_fur_color) +
  stat_smooth(se = FALSE, span = 0.8) +
  labs(
    title = 'Decreasing Count of Squirrels Through Time',
    subtitle = 'Moving average smoother estimate',
    x = 'Date of Observation',
    y = 'Count of Squirrels',
    color = 'Primary Fur Color'
  ) +
  coord_cartesian( # The full data is feeding here, but I'm limiting the coordinate
    # system to only what I want to show
    xlim = c(as.Date.character('2018-10-08'),
             as.Date.character('2018-10-15')),
    ylim = c(-10,110)
  ) +
  theme_minimal() # Don't technically need this anymore because we've set the theme above

# If you want more themes, you can go to this:
#   install.packages('ggthemes', dependencies = TRUE)
#   library(ggthemes)



