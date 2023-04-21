# Load packages
library(tidyverse)

# Load Statistics Canada Table 13-10-0394
heart <- read_csv(file = "13100394.csv")

# Keep only the variables that are needed
heart <- heart %>%
  select(REF_DATE, `Age at time of death`, Sex,
         `Leading causes of death (ICD-10)`, Characteristics,
         VALUE)

# Rename columns 
colnames(heart) <- c("year", "age", "sex", 
                     "cause", "stat", "value")

# Filter out rows that aren't about heart disease
heart <- heart %>% 
  filter(cause == "Diseases of heart [I00-I09, I11, I13, I20-I51]") %>%
  select(-cause)

# Filter out rows broken down by sex
heart <- heart %>% 
  filter(sex == "Both sexes") %>% 
  select(-sex)

# Remove "age at time of death" from age variable 
heart <- heart %>%
  mutate(age = substr(age, start = 23, stop = nchar(age)))

# Make "all ages"
heart <- heart %>% 
  mutate(age = ifelse(age == "all ages", "All ages", age))

# Create the tables for Displayr -----------------------------------------------

# Populate age group dropdown options 
ages <- unique(heart$age)
clipr::write_clip(ages)

# Leading cause of death in 2020
lead <- heart %>% 
  filter(stat == "Rank of leading causes of death") %>%
  filter(year == 2020) %>% 
  select(-c(stat, year)) %>% 
  pivot_wider(names_from = age, values_from = value)
clipr::write_clip(lead)

# Percentage of deaths in 2020 
percentage_death <- heart %>% 
  filter(stat == "Percentage of deaths") %>%
  filter(year == 2020) %>% 
  select(-c(stat, year)) %>% 
  pivot_wider(names_from = age, values_from = value)
percentage_death <- percentage_death %>% 
  add_row(100 - percentage_death[1, ])
row.names(percentage_death) <- c("Heart Disease",
                                 "Other")
clipr::write_clip(percentage_death)

# Number of deaths bar chart
num_death <- heart %>% 
  filter(stat == "Number of deaths") %>% 
  select(-stat) %>% 
  pivot_wider(names_from = age, values_from = value)
clipr::write_clip(num_death)

# Code used in Displayr directly -----------------------------------------------

# Rank of leading cause of death in 2020
paste0("#", leading[,age_dropdown])

# Pie chart: Percentage of deaths due to heart disease in 2020
flipStandardCharts::Chart(percent_death[,age_dropdown],
                          type = "Pie", 
                          colors = c("#4475af", "#eaf3fc"),
                          data.label.font.color = "#4475af",
                          data.label.font.size = 24,
                          data.label.font.family = "Open Sans",
                          data.label.decimals = 0,
                          data.label.suffix = "%")

# Bar chart: Number of deaths due to heart disease in Canada per year
flipStandardCharts::Chart(num_deaths[, age_dropdown], 
                          type = "Column",
                          background.fill.color = "#eaf3fc",
                          charting.area.fill.color = "#eaf3fc",
                          colors = "#fb6540", 
                          x.tick.font.color = "#4775af",
                          x.tick.font.size = 20,
                          x.grid.width = 0,
                          x.tick.font.family = "Open Sans",
                          x.tick.format.manual = "c",
                          y.tick.font.color = "#4775af",
                          y.tick.font.size = 20,
                          y.title.font.color = "#4775af",
                          y.tick.font.family = "Open Sans",
                          y.tick.format.manual = ",",
                          y.grid.width = 0)
