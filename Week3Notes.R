
### Tidyverse

iris_tbl <- dplyr::as_tibble(iris)
class(iris_tbl)
str(iris_tbl)
iris_tbl



### Delimited Data

library(tidyverse)

## Locating Files

bike_details <- read_csv("https://www4.stat.ncsu.edu/~online/datasets/bikeDetails.csv")
head(bike_details)

# Aside from the special printing, tibbles have one other important difference from data frames: they do not coerce down to a vector when you subset to only one column using [

bike_details[1:10,1]
as.data.frame(bike_details)[1:10 ,1]
bike_details$name[1:10]

bike_details[1:10, ] |>
  pull(name)

# the guess_max argument tells our function to scan the first x number of rows and try to determine the column type. Note it says you may need to increase that argument to make sure data can be read in.

#Checking column type is a basic data validation step! 

#You should check that each column was read in the way you would expect. If not, you may need to clean the data and convert the column to the appropriate data type.



# We can use read_delim() to read in a generic delimited raw data file

ump_data <- read_delim("https://www4.stat.ncsu.edu/~online/datasets/umps2012.txt", 
                       delim = ">",
                       col_names = c("Year", "Month", "Day", "Home", "Away", "HPUmpire")
)

ump_data


# We see that the first three columns represent a Year, Month, and Day. These are currently stored as dbl (numeric data). Obviously, that’s not great. We can’t easily subtract two dates to get the difference in time or anything like that.

# Insert the lubridate package. This is the tidyverse package for dealing with dates!

library(lubridate)
help("lubridate")

# Ok, so we want to use ymd() or a variant and pass it a character string of the date to parse! No problem, we know how to do that :)


# Under the help for the ymd() function, examples are given at the bottom of how to use the function. One example is

x <- c("09-01-01", "09-01-02", "09-01-03")
ymd(x)


# Let’s write a quick loop to loop through our observations, create this type of character string, and output a date variable!

ump_data$date <- ymd("2012-01-01")
ump_data

for (i in 1:nrow(ump_data)){
  ump_data$date[i] <- ymd(paste(ump_data$Year[i],
                                ump_data$Month[i],
                                ump_data$Day[i], 
                                sep = "-"))
}
ump_data


# Great! Now we can subtract dates and do other useful things with date data. We’ll cover this kind of code shortly but we might want to know the days between being home plate umpire:

ump_data |>
  filter(HPUmpire == "Marty Foster") |>
  mutate(days_off = date - lag(date))

# This is easily done as we can take a date and subtract another date (via lag(date), which grabs the date from the previous row).



# Sometimes our raw data will be in a .txt type file but not in a super nice format. In that case, we have a few functions that can help us out:

# read_file()
   # reads an entire file into a single string

# read_lines()

   # reads a file into a character vector with one element per line




### Rading Excel Data

## READXL package

# The readxl package is part of the tidyverse (not loaded by default) that has functionality for reading in this type of data!

library(readxl)
dry_bean_data <- read_excel("Dry_Bean_Dataset.xlsx")
dry_bean_data

# Great! Easy enough. If the file was in one folder up from your .qmd file, you could read it in via
dry_bean_data <- read_excel("../Dry_Bean_Dataset.xlsx")

# If the file had been in a folder called datasets located one folder up from your .qmd file, you could read it in via
dry_bean_data <- read_excel("../datasets/Dry_Bean_Dataset.xlsx")



## Reading From a Particular Sheet

# We might want to programmatically look at the sheets available in the excel document. This can be done with the excel_sheets() function.
excel_sheets("Dry_Bean_Dataset.xlsx")

# We can pull in data from a specific sheet with the name or via integers (or NULL for 1st)
citation_dry_bean_data <- read_excel("Dry_Bean_Dataset.xlsx", 
                                     sheet = excel_sheets("Dry_Bean_Dataset.xlsx")[2])
citation_dry_bean_data

# Notice that didn’t read in correctly! There is only one entry there (the 1st cell, 1st column) and it is currently being treated as the column name. Similar to the read_csv() function we can use col_names = FALSE here (thanks coherent ecosystem!!).

citation_dry_bean_data <- read_excel("Dry_Bean_Dataset.xlsx", 
                                     sheet = excel_sheets("Dry_Bean_Dataset.xlsx")[2],
                                     col_names = FALSE)
citation_dry_bean_data


# We can see there are some special characters in there (like line break). If we use cat() it will print that out nicely.
cat(dplyr::pull(citation_dry_bean_data, 1))



## Reading Only Specific Cells
dry_bean_range <- read_excel("Dry_Bean_Dataset.xlsx", 
                             range = cell_cols("A:B")
)
dry_bean_range



### Manipulating Data with DPLYR

library(dplyr)
library(Lahman)
batting_tbl <- as_tibble(Batting)
batting_tbl


## Row Manipulations with dplyr

filter(batting_tbl, G > 50)

batting_tbl |>
  filter(G > 50 & yearID == 2018)

#equivalently
batting_tbl |>
  filter(G > 50, yearID == 2018)

batting_tbl |>
  filter(G > 50, yearID %in% c(2018, 2019, 2020))

batting_tbl |>
  filter(G > 100 | yearID %in% c(2018, 2019, 2020))

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(teamID)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(teamID, playerID)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID)


## Column Manipulations with DPLYR

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H, X2B, X3B, HR)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(ends_with("ID"), G, AB, H:HR)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(ends_with("ID") | starts_with("X"), G, AB, H, HR)


# if our goal is really just to reorder the columns, we can use everything() after specifying the columns of interest
batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, H:HR, everything())




batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B")


## Creating New Variables with dplyr

# This can be accomplished using mutate(). This function allows us to create one or more variables and append them to our tibble.

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits) |>
  select(playerID, teamID, Singles, Doubles:HR, H, Extra_Base_Hits)


# We can of course use lots of functions when creating a new variable as well. Some common functions are log(), lead(), lag(), percent_rank(), cumsum(), etc. (see the help for mutate for a nice list).

# Let’s use percent_rank() to get a new column telling us where they rank for number of hits

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits,
         H_Percentile = percent_rank(H)) |>
  select(playerID, teamID, H, H_Percentile, everything()) 

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits,
         H_Percentile = percent_rank(H),
         H_Mean = mean(H)) |>
  select(playerID, teamID, H, H_Mean, H_Percentile, everything()) 


# Useful, but what if we want to show the mean by team? Easy to do in dplyr using group_by()!

# If we add group_by() in our chain, any summary statistics created will honor those groups (ungroup() exists if you want to remove a grouping).

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  group_by(teamID)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  group_by(teamID) |>
  attributes()


# Let’s find our mean relative to each team using a group_by() in our chain (this finds the percentile by teamID as well).

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  group_by(teamID) |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits,
         H_Percentile = percent_rank(H),
         H_Mean = mean(H)) |>
  select(playerID, teamID, H, H_Mean, H_Percentile, everything()) |>
  print(n = 50)

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, yearID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  group_by(teamID, yearID) |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits,
         H_Percentile = percent_rank(H),
         H_Mean = mean(H)) |>
  select(playerID, teamID, yearID, H, H_Mean, H_Percentile, everything())


# We are really able to do a lot quickly with these functions! Nice. One other commonly used function in mutate() is ifelse() or if_else() (the tidyverse version with slightly more restrictive functionality).

# Recall ifelse() takes in a vector of conditions as the first argument. The second argument is what to do when TRUE and the third what to do when FALSE.

batting_tbl |>
  filter(G > 100, yearID %in% c(2018, 2019, 2020)) |>
  arrange(desc(teamID), playerID) |>
  select(playerID, yearID, teamID, H:HR) |>
  rename("Doubles" = "X2B", "Triples" = "X3B") |>
  group_by(teamID, yearID) |>
  mutate(Extra_Base_Hits = Doubles + Triples + HR,
         Singles = H - Extra_Base_Hits,
         H_Percentile = percent_rank(H),
         H_Mean = mean(H),
         Status = ifelse(H > H_Mean, 
                         "Great", 
                         "Needs some work")) |>
  select(playerID, teamID, yearID, H, H_Mean, Status, H_Percentile, everything())



## Cleaning Names

library(janitor)
air_quality_data <- readr::read_csv("https://www4.stat.ncsu.edu/~online/datasets/AirQuality.csv")
names(air_quality_data)

clean_names(air_quality_data) |>
  names()
# This function, by default, converts things to lower snake case!



### Manipulating Data with TIDYR

# We now have a good handle on common actions we want to take on our data frames. However, we’ve been treating our data as though it is already in long format where each row consists of one observation and each column one variable.

#This isn’t always the case! Sometimes we have wide format data where we may have more than one observation in a given row.



## tidyr Package

library(readr)
temps_data <- read_table(file = "https://www4.stat.ncsu.edu/~online/datasets/cityTemps.txt") 
temps_data

# Switch to ‘Long’ form with pivot_longer(). Checking the help, the major arguments are:
  # cols = columns to pivot to longer format (cols = 2:8)
  # names_to = new name(s) for columns created (names_to = "day")
  # values_to = new name(s) for data values (values_to = "temp")


library(tidyr)
temps_data |>
  pivot_longer(cols = 2:8, 
               names_to = "day", 
               values_to = "temp")

# That’s better! Now each row has one observation in it. Recall we had a lot of functionality for selecting columns within the tidyverse. That holds here as well!

temps_data |>
  pivot_longer(cols = sun:sat, 
               names_to = "day", 
               values_to = "temp")


# Occasionally we’ll want to make our data wider for display purposes. We can make this switch to ‘Wide’ form with pivot_wider(). There are two major arguments we must specify:

  # names_from = column(s) to get the names used in the output columns
  # values_from = column(s) to get the cell values from

library(dplyr)
library(Lahman)
batting_tbl <- as_tibble(Batting)
batting_tbl


# We may want to get just the data for one team (say the Pirates) and display each players number of hits across the years 2018 to 2020.

  # Let’s subset the data to get just the pirates (teamID == "PIT")
  # Then we’ll select only their hits and year columns (playerID, H, and yearID)
  # Then we need to pivot that data set wider so that we have the year across the top (names_from), the players as the rows, and the          entries as the hits (values_from)


batting_tbl |>
  filter(yearID %in% 2018:2020, teamID == "PIT") |>
  select(playerID, yearID, H) |>
  pivot_wider(names_from = yearID, values_from = "H")


# Great! You can see that missing values are filled in for those that didn’t play in a given year. Let’s subset this to remove any rows with missing values (so we only get players that played for the pirates in all three years).

# The tidyr function drop_na() does this exact thing for us!


batting_tbl |>
  filter(yearID %in% 2018:2020, teamID == "PIT") |>
  select(playerID, yearID, H) |>
  pivot_wider(names_from = yearID, values_from = "H") |>
  drop_na()

# Let’s also remove those with 0 hits:

batting_tbl |>
  filter(yearID %in% 2018:2020, teamID == "PIT", H > 0) |>
  select(playerID, yearID, H) |>
  pivot_wider(names_from = yearID, values_from = "H") |>
  drop_na()


# The column names 2018, 2019, and 2020 are non-standard names as they start with a number. That’s not ideal so let’s rename those too!
batting_tbl |>
  filter(yearID %in% 2018:2020, teamID == "PIT", H > 0) |>
  select(playerID, yearID, H) |>
  pivot_wider(names_from = yearID, values_from = "H") |>
  drop_na() |>
  rename('year2018' = `2018`,
         'year2019' = `2019`,
         'year2020' = `2020`)

batting_tbl |>
  filter(yearID %in% 2018:2020, teamID == "PIT", H > 0) |>
  select(playerID, yearID, H) |>
  pivot_wider(names_from = yearID, values_from = "H") |>
  drop_na() |>
  rename('year2018' = `2018`,
         'year2019' = `2019`,
         'year2020' = `2020`) |>
  dplyr::inner_join(select(People, playerID, nameFirst, nameLast)) |>
  select(nameFirst, nameLast, everything())


## Column Manipulations with tidyr

# Separate a column using separate_wider_delim() (a few other variants exist as well)
# Combine two columns with unite()

chicago_data <- read_csv("https://www4.stat.ncsu.edu/~online/datasets/Chicago.csv")
chicago_data


# Although we saw that we should treat date variables as date objects (say from lubridate), we could manually separate out the dates we see here. We can notice that the month comes first followed by a /, then the day, a /, and the year.

  # We can split on the delimiter /
  # The arguments to give separate_wider_delim() are:
  
    # cols = the columns we want
    # delim = the delimiter
    # names = new names for the split variables
    # cols_remove - binary, whether to remove the original column or not

chicago_data |>
  separate_wider_delim(cols = date, 
                       delim = "/", 
                       names = c("Month", "Day", "Year"), 
                       cols_remove = FALSE)


# Nice! These are character strings so we might want to turn them into numbers but, again, we’d really want to use date type data for these anyway.

  # unite() allows us to combine two columns into one

    # Perhaps we want a new column with the date and the season together (for display purposes)
    # We just pass unite() the name of the new column (col =), the columns we want to combine, and the separator to use (sep =)

chicago_data |>
  unite(col = "season_date", season, date, sep = ": ") |>
  select(season_date, everything())

