
# propublica.R File

library(dplyr)
library(httr)
library(kableExtra)
library(jsonlite)
library(ggplot2)
library(lintr)

source("api-keys.R") # Load the Script using a relative path

# Assign my State a Variable
address <- "wa"

# Set the Base URI
propublica_uri <- "https://api.propublica.org/congress/v1"

# Set the endpoint of my URI
endpoint2 <- paste0("https://api.propublica.org/",
                    "congress/v1/members/house/wa/current.json")

# Set my full URI including my API Key
search_uri2 <- paste0(propublica_uri, endpoint2)

# Set the Parameters of my API
query_params2 <- (address2 <- "wa")

# Use a GET function to gather information about my URI
response2 <- GET(endpoint2, add_headers("X-API-Key" = propublica_api_key))

# Extract content from response as a text string
response_text2 <- content(response2, type = "text")

# Convert the JSON string to a list
response_data2 <- fromJSON(response_text2)

# Checking to see if its already a data frame
is.data.frame(response_data2) # FALSE

# Inspecting the data
str(response_data2)

# Retrieving the names within the list
names(response_data2)
# Returns the names "status", "copyright", "results"

# Finding names that are already data frames:
is.data.frame(response_data2$status) # False
is.data.frame(response_data2$copyright) # False
is.data.frame(response_data2$results) # TRUE - THIS IS VALUABLE!

# Flattening the "response_data$results" data frame
results <- flatten(response_data2$results)

# Assigning Male and Female representatives a Value
male_reps <- length(grep("M", results$gender)) # 5
female_reps <- length(grep("F", results$gender)) # 5

# Bar Plot that shows the number of Male and Female Representatives
# within the state. 
reps_by_gender_plot <- barplot( c(male_reps, female_reps),
        main = "Representatives by Gender
        within the State", names.arg = c("Male", "Female"))

# Assigning Democrat and Republican Representatives a Value
democrat <- length(grep("D", results$party)) # 7
republican <- length(grep("R", results$party)) # 3

# Bar Plot that shows the number of Democrats versus the number 
# of Republicans within the state. 
reps_by_party_plot <- barplot( c(democrat, republican),
        main = "Number of Democrat and Republican Representatives
        within the State", names.arg = c("Democrat", "Republican"))

#-------------------------------------------------------------------
  
# Set the Endpoint
endpoint3 <- paste0("https://api.propublica.org/congress/v1/",
                    "members/D000617.json")

# Use a GET function to gather information about my URI
response3 <- GET(endpoint3, add_headers("X-API-Key" = propublica_api_key))
  
# Extract content from response as a text string
response_text3 <- content(response3, type = "text")

# Convert the JSON string to a list
response_data3 <- fromJSON(response_text3)

# Checking to see if its already a dataframe
is.data.frame(response_data3) # False

names(response_data3)
is.data.frame(response_data3$status) # False
is.data.frame(response_data3$copyright) # False
is.data.frame(response_data3$results) # TRUE!

# Flattening the "response_data3$results" data frame
suzan <- flatten(response_data3$results)

#--------------------------------------------------------------------

# Set the Endpoint
endpoint4 <- paste0("https://api.propublica.org/congress/v1/members/D000617/",
                    "votes.json")

# Use a GET function to gather information about my URI
response4 <- GET(endpoint4, add_headers("X-API-Key" = propublica_api_key))

# Extract content from response as a text string
response_text4 <- content(response4, type = "text")

# Convert the JSON string to a list
response_data4 <- fromJSON(response_text4)

# Checking to see if its already a dataframe
is.data.frame(response_data4) # False

names(response_data4)
is.data.frame(response_data4$status) # False
is.data.frame(response_data4$copyright) # False
is.data.frame(response_data4$results) # TRUE!

# Flattening the "response_data4$results" data frame
suzan_votes <- flatten(response_data4$results)

# Making a Hyperlink for DelBene's Twitter Account
suzan_twitter <- paste0("[", "click here", "]", "(https://twitter.com/",
                                              "RepDelBene", ")" )

# How to calulate Suzan's Voting Percentage
suzan_total_votes <- suzan_votes$votes[[1]][["position"]]

suzan_yes <- length(grep("Yes", suzan_total_votes)) # 16
suzan_no <- length(grep("No", suzan_total_votes)) # 4

lint("propublica.R")
