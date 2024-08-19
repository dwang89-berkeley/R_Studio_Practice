library(tidyverse)
library(ggplot2)
library(patchwork)

# Loading in Citi data
citi_data_file_name =
  'MTS_Trail_west_of_I-90_Bridge_Bicycle_and_Pedestrian_Counter__Out_of_Service__20240814.csv'
citi_data_raw <- read.csv(citi_data_file_name)

# Mutating bike date data to be more useable
citi_data <- citi_data_raw %>% 
  mutate(year = substr(Date, start = 7, stop = 10)) %>%
  mutate(month = substr(Date, start = 1, stop = 2)) %>%
  mutate(day = substr(Date, start = 4, stop = 5)) %>%
  mutate(hour = substr(Date, start = 12, stop = 13)) %>%
  mutate(true_hour = case_when(
    substr(Date, start = 21, stop = 22) == 'PM' & substr(Date, start = 12, stop = 13) != '12'~ as.numeric(hour)+12,
    substr(Date, start = 21, stop = 22) == 'PM' & substr(Date, start = 12, stop = 13) == '12'~ as.numeric(hour),
    substr(Date, start = 21, stop = 22) == 'AM' & substr(Date, start = 12, stop = 13) == '12'~ 0,
    substr(Date, start = 21, stop = 22) == 'AM' ~ as.numeric(hour)
  )) %>%
  mutate(timestamp_new = as.POSIXct(Date, format="%m/%d/%Y %H:%M:%S"),
         weekday = weekdays(timestamp_new))

citi_data[100:130,] # need the comma to see certain rows

# Are there more east-bound or west-bound rides at certain parts of the day?
  # Why might this be?
summary_data <- citi_data %>%
  group_by(true_hour) %>%
  summarize(east_bikers_count = sum(Bike.East, na.rm = TRUE),
            west_bikers_count = sum(Bike.West, na.rm = TRUE))

long_data <- summary_data %>%
  pivot_longer(cols = c(east_bikers_count, west_bikers_count), 
               names_to = "direction", 
               values_to = "total_bikers")

long_data_plot <- long_data %>%
  ggplot() +
  aes(x = true_hour, y = total_bikers, color = direction) +
  geom_line() +
  labs(
    title = 'East and West Bikers by Direction',
    x = 'Hour of day',
    y = 'Total bikers',
    color = 'Biker direction'
  )

long_data_plot
# From the morning to lunch, and when the work day ends
  

# Are there months of the year that there are more (or fewer) total rides?
months_data <- citi_data %>%
  group_by(month) %>%
  summarize(east_bikers = sum(Bike.East, na.rm = TRUE),
            west_bikers = sum(Bike.West, na.rm = TRUE)) %>%
  mutate(month = as.numeric(month))

months_data_long <- months_data %>%
  pivot_longer(cols = c(east_bikers, west_bikers),
               names_to = "direction",
               values_to = "total_bikers")

months_data_long %>%
  ggplot() +
  aes(x = month, y = total_bikers, color = direction) +
  geom_line() +
  scale_x_continuous(breaks = seq(2, 12, by = 2)) +
  labs(
    title = 'East and West Bikers by Direction',
    x = 'Month',
    y = 'Total bikers',
    color = 'Biker direction'
  )
# So yes, from May through August (the summer months)
  
  
# Are the weekends different from the weekdays?
  days_data <- citi_data %>%
    group_by(weekday) %>%
    summarize(east_bikers = sum(Bike.East, na.rm = TRUE),
              west_bikers = sum(Bike.West, na.rm = TRUE))
  
  days_data_long <- days_data %>%
    pivot_longer(cols = c(east_bikers, west_bikers),
                 names_to = "direction",
                 values_to = "total_bikers")
  
  days_data_long %>%
    ggplot() +
    aes(weekday, total_bikers, fill = direction) +
    geom_bar(stat = "identity", position = 'dodge') +
    labs(
      title = 'East and West Bikers by Direction',
      x = 'Day',
      y = 'Total bikers',
      color = 'Biker direction'
    ) +
    theme(axis.text.x=element_text(angle = 90, hjust = 1, vjust = 0.5))
# Saturdays and Sundays have the most east and west bikers

  
# Checking to see what happens when you do only weekdays
days_data_2 <- citi_data %>%
  filter(weekday != 'Sunday', weekday != 'Saturday') %>%
  group_by(weekday) %>%
  summarize(east_bikers = sum(Bike.East, na.rm = TRUE),
            west_bikers = sum(Bike.West, na.rm = TRUE)) %>%
  pivot_longer(cols = c(east_bikers, west_bikers),
               names_to = "direction",
               values_to = "total_bikers")

  days_data_2 %>%
    ggplot() +
    aes(weekday, total_bikers, fill = direction) +
    geom_bar(stat = "identity", position = 'dodge') +
    labs(
      title = 'East and West Bikers by Direction',
      x = 'Day',
      y = 'Total bikers',
      color = 'Biker direction'
    ) +
    theme(axis.text.x=element_text(angle = 90, hjust = 1, vjust = 0.5))


# Now checking to see what happens to hour chart on weekdays
hours_data_2 <- citi_data %>%
  filter(weekday != 'Sunday', weekday != 'Saturday') %>%
  group_by(true_hour) %>%
  summarize(east_bikers_count = sum(Bike.East, na.rm = TRUE),
            west_bikers_count = sum(Bike.West, na.rm = TRUE)) %>%
  pivot_longer(cols = c(east_bikers_count, west_bikers_count), 
               names_to = "direction", 
               values_to = "total_bikers")

hours_data_2_plot <- hours_data_2 %>%
  ggplot() +
  aes(x = true_hour, y = total_bikers, color = direction) +
  geom_line() +
  labs(
    title = 'East and West Bikers on Weekdays',
    x = 'Hour of day',
    y = 'Total bikers',
    color = 'Biker direction'
  )

hours_data_2_plot
# When filtering out weekends, we see that the most popular times for the bike
# are in the morning when people are getting to work, and later in the day when
# people are coming home from work. Also, the discrepancy betwen bikers going
# east and west is not as dramatic

long_data_plot / hours_data_2_plot


# Trying only weekends now
hours_data_3 <- citi_data %>%
  filter(weekday == 'Sunday' | weekday == 'Saturday') %>%
  group_by(true_hour) %>%
  summarize(east_bikers_count = sum(Bike.East, na.rm = TRUE),
            west_bikers_count = sum(Bike.West, na.rm = TRUE)) %>%
  pivot_longer(cols = c(east_bikers_count, west_bikers_count), 
               names_to = "direction", 
               values_to = "total_bikers")

hours_data_3_plot <- hours_data_3 %>%
  ggplot() +
  aes(x = true_hour, y = total_bikers, color = direction) +
  geom_line() +
  labs(
    title = 'East and West Bikers on Weekends',
    x = 'Hour of day',
    y = 'Total bikers',
    color = 'Biker direction'
  )

hours_data_3_plot
# The rides seem to be the most common in the day on the weekends

long_data_plot / hours_data_2_plot / hours_data_3_plot


# Btw, if you wanted to put the plots next to each other (or above) using facet_wrap,
# you would've had to put all the data in the same csv

