# Sida Chhun
# a5 Assignment

# Adding libraries to file
library(dplyr)
library(plotly)
library(leaflet)
library(sp)
library(stringr)
library(data.table)
library(kableExtra)
library(knitr)
library(lintr)

# Reading shootings-2018 dataset into this file
shootings_2018 <- read.csv("data/shootings-2018.csv", stringsAsFactors = FALSE)

# Number of mass shootings occured in the 2018 shootings dataset
shootings_occured <- nrow(shootings_2018)

# Number of lives lost in 2018 due to mass shootings
lives_lost <- sum(shootings_2018$num_killed)

# City with the deadliest mass shooting in 2018
most_impacted_city <- shootings_2018 %>%
  filter(num_killed == 17) %>%
  select(city)
# Two other insights:

# 1. Rounded Average amount of injuries per mass shooting
avg_injuries_per_shooting <- round(mean(shootings_2018$num_injured))

# 2. Number of unique states affected within the country
number_of_states_affected <- length(unique(shootings_2018$state))

# Frequency of shooting filtered by state
state_frequency <- table(shootings_2018$state)

# Overall General shooting statistics in the US
general_shooting_stats <- data.frame(shootings_occured,
                                     lives_lost,
                                     avg_injuries_per_shooting,
                                     number_of_states_affected
)

# Condensed quickview of shooting in the US
Quick_View_Stats <- data.table(shootings_2018)

# Convert `state_frequency` to dataframe:
df_state_frequency <- data.frame(state_frequency)

# Number of Florida Mass Shootings
florida_shootings <- df_state_frequency[9, 2]

# Parkland Shooting Information:
parkland_information <- shootings_2018 [312, ]

# The date of the parkland shooting
parkland_date <- parkland_information$date

# The state of the parkland shooting
parkland_state <- parkland_information$state

# The city of the parkland shooting
parkland_city <- parkland_information$city

# The number killed in the parkland shooting
parkland_num_killed <- parkland_information$num_killed

# The number injured in the parkland shooting
parkland_num_injured <- parkland_information$num_injured

# Creating an Interactive Map

data <- read.csv("data/shootings-2018.csv")
data <- data[complete.cases(data), ]

data$long <- as.numeric(data$long)
data$lat <- as.numeric(data$lat)

data.sp <- SpatialPointsDataFrame(data[, c(7, 8)], data[, -c(7, 8)])

# Adding additional data to markers
map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(data = data, lng = ~long, lat = ~lat,
             popup = paste("City:", data$city, "<br>",
                           "State:", data$state, "<br>",
                           "Number Killed:", data$num_killed, "<br>",
                           "Number Injured:", data$num_injured)
                           )

# Making a plot

mass_shootings_plot <- plot_ly(
  data = df_state_frequency, # data frame to show
  x = ~df_state_frequency$Freq, # variable for the x-axis,
  y = df_state_frequency$Var1, # variable for the y-axis
  type = "bar", # created a bar chart
  alpha = .7, # adjusted opacity
  hovertext = "y" # show the y-value when hovering over a bar
) %>%
  layout(
    title = "Bar-Chart of 2018 Mass Shootings Frequency by State",
    xaxis = list(title = "Total Mass Shootings"),
    yaxis = list(title = "States"))

lint("analysis.R")