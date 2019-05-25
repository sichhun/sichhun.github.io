# civic-info.R File

library(dplyr)
library(httr)
library(knitr)
library(kableExtra)
library(jsonlite)
library(lintr)

source("api-keys.R") # Load the script using a relative path

# Set the Base URI
civic_uri <- "https://www.googleapis.com/civicinfo/v2/"

# Set the Endpoint of my URI
endpoint1 <- paste0("representatives")

# Set my full URI including my API key
search_uri1 <- paste0(civic_uri, endpoint1, "?key=", google_api_key)

# Set the parameters for my URI
query_params <- list(
  address = "5000 25th Ave NE",
  k = google_api_key
)

# Use a GET function to gather information about my URI
response <- GET(
  search_uri1, query = query_params
)

# Check for Success (Code 200)
print(response)

# Extract content from response as a text string
response_text <- content(response, type = "text")

# Convert the JSON string to a list
response_data <- fromJSON(response_text)

# Checking to see if its already a data frame
is.data.frame(response_data) # FALSE

# Inspecting the data
str(response_data)

# Retrieving the names within the list
names(response_data)
# Returns the names "kind", "normalizedInput", "divisions", "offices",
# "officials"

# Finding names that are already data frames:
is.data.frame(response_data$kind) # False
is.data.frame(response_data$normalizedInput) # False
is.data.frame(response_data$divisions) # False
is.data.frame(response_data$offices) # TRUE - THIS IS VALUABLE!
is.data.frame(response_data$officials) # TRUE - THIS IS ALSO VALUABLE!

# Flattening the Offices data frame from response_data
offices <- flatten(response_data$offices)
# Flattening the Officials data frame from response_data
officials <- flatten(response_data$officials)

# Expanding "offices" dataframe by given indices 
num_to_rep <- unlist(lapply(response_data$offices$officialIndices, length))
expanded <- offices[rep (row.names (offices), num_to_rep), ]
new_officials <- officials %>% mutate(index = row_number()-1)
new_offices <- expanded %>% mutate(index = row_number() -1) %>% 
  rename(position = name)

# Selecting Only Necessary Columns from the "new_officials" Data Frame
new_officials <- select(new_officials, name, party, phones)

# Selecting Only Necessary Columns from the "Offices" Data Frame
select_offices <- select(new_offices, position)

# Renaming Single Column in "select_offices" Data Frame to "Position"
colnames(select_offices)[colnames(select_offices) == "name"] <- "Position"

# Renaming ALL columns names in "select_officials" Data Frame as Capitalized
colnames(new_officials) <- c("Name", "Party", "Phone")

# Adding Hyperlinks to Candidates' Names
Name <- paste0("[", (officials$name), "]",
                          "(", (officials$urls), ")")

# Convert "officials$emails" to Character rather than list
names(unlist(officials$emails))

# ifelse function to replace missing emails with the text "Not Available"
Email <- ifelse((officials$emails == "NULL"), paste0( "Not Available"),
                      paste0(officials$emails))


# ifelse function to replace missing photo urls with the text
# "No Picture Available"

Photo <- ifelse((is.na(officials$photoUrl) == F), paste0( 
  "![](", officials$photoUrl, ")"), paste0("No Photo Available"))

# Removing Names column from "new_officials" dataframe
final_officials <- new_officials[-1]


# Mutating All Data Frames Together
combined_data <- mutate(
  final_officials,
  Name,
  #select_offices,
  # KEEP GETTING ERROR: Column "select_offices" is of unsupported class
  # data.frame. No Google Search Results to match error.
  Email,
  Photo
)

# Rearranging Columns 
arranged_data <- arrange(combined_data, Party, Name,
                         Photo)
lint("civic-info.R")
