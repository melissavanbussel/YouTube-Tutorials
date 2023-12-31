# Load packages
library(tidyverse)
library(plotly)

# Load csv with time tracking information
time_df <- read.csv("time_tracking.csv")

# Get variables in usable format
time_df <- time_df %>% 
  mutate(time_spent = str_replace(time_spent, pattern = "m", replacement = "M")) %>% 
  mutate(
    time_spent = period(time_spent),
    date = as.Date(substr(date, start = 1, stop = nchar(date) - 20), format = "%B %d, %Y"),
    milestone = factor(milestone)
  ) %>%
  select(-user)

# Fix dates that are in the future
time_df <- time_df %>% 
  mutate(date = case_when(
    date == as.Date("2023-12-22") ~ as.Date("2023-12-29"),
    date == as.Date("2023-12-23") ~ as.Date("2023-12-30"),
    1 == 1 ~ date
  ))

# Convert dates to numbers
start_date <- min(time_df$date)
end_date <- max(time_df$date)
date_seq <- seq.Date(from = start_date, to = end_date, by = 1)
dates_as_numbers <- data.frame(date = date_seq,
                               date_num = 1:length(date_seq))
time_df <- time_df %>% 
  left_join(dates_as_numbers)

# Create one row per milestone-date combination
temp <- data.frame(milestone = rep(unique(time_df$milestone), length(date_seq))) %>%
  arrange(milestone) %>% 
  mutate(date_num = rep(unique(dates_as_numbers$date_num), length(unique(time_df$milestone)))) %>% 
  left_join(time_df %>% select(milestone, date_num, time_spent)) %>%
  mutate(time_spent = replace_na(time_spent, period(0)))

# Create cumulative sums 
to_plot <- temp %>% 
  group_by(milestone) %>% 
  mutate(cum_sum = cumsum(as.numeric(time_spent)) / 3600) %>%
  ungroup()

# Create plot
to_plot %>% 
  plot_ly() %>% 
  add_bars(y = ~milestone, x = ~cum_sum, frame = ~date_num, ids = ~milestone, type = "bar") %>%
  hide_legend() %>% 
  animation_opts(frame = 100, transition = 100) %>% 
  layout(xaxis = list(title = ""),
         yaxis = list(title = ""),
         title = list(text = "Time tracking for Dec. 24th - 30th, 2023"),
         margin = list(t = 100))
