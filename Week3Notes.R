
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

