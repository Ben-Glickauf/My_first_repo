library(tidyverse)
library(tibble)


help(apply)
# lets us apply a function over something that is HOMOGONEOUS

library(Lahman)
my_batting <- Batting[, c("playerID", "teamID", "G", "AB", "R", "H", "X2B", "X3B", "HR")] |>
  as_tibble()
my_batting


apply(X = my_batting,
      MARGIN = 2, # to each COLUMN
      FUN = summary, # apply the summary() function to each column
      na.rm = TRUE) # any excess arguments to summary() can go here


# try it with the numeric data
batting_summary <- apply(X = my_batting |>
                           select(where(is.numeric)),
                         MARGIN = 2,
                         FUN = summary,
                         na.rm = TRUE)
batting_summary


# We often use our own custom functions with the apply() family
custom_batting_summary <- apply(X = my_batting |>
                                  select(where(is.numeric)),
                                MARGIN = 2,
                                FUN = function(x){
                                  temp <- c(mean(x), sd(x))
                                  names(temp) <- c("mean", "sd")
                                  temp
                                }
)
custom_batting_summary



custom_batting_summary <- apply(X = my_batting |>
                                  select(where(is.numeric)),
                                MARGIN = 2,
                                FUN = function(x, trim){
                                  temp <- c(mean(x, trim), sd(x))
                                  names(temp) <- c("mean", "sd")
                                  temp
                                },
                                trim = 0.1
)
custom_batting_summary


# LAPPLY()
help(lapply)

set.seed(10)
my_list <- list(rnorm(100), runif(10), rgamma(40, shape = 1, rate = 1))

# Apply mean() function to each list element
lapply(X = my_list, FUN = mean)

# To give additional arguments to FUN we add them on afterward
lapply(X = my_list, FUN = mean, trim = 0.1, na.rm = TRUE)


# SAPPLY() -- Similar function but it attempts to simplify when possible
help(sapply)
sapply(X = my_list, FUN = mean, trim = 0.1, na.rm = TRUE)


# RECAP

  # Vectorized functions fast!

  # apply() family is sort of vectorized
  # lapply() and sapply() to apply a function to a list
  # aggregate(), replicate(), tapply() vapply(), and mapply() also exist!





# purrr Package

# MAP()

  # Always returns a list
  # First arg is the list, second is the function
set.seed(10)
my_list <- list(rnorm(100), runif(10), rgamma(40, shape = 1, rate = 1))
map(my_list, mean)


# Allows for shorthand
# Suppose we want the second element of each list. Compare:
map(my_list, 2)

lapply(my_list, function(x) x[[2]])
lapply(my_list, `[[`, 2)

# purrr functions also give a shorthand way to make anonymous functions
map(my_list, \(x) mean(x))
map(my_list, \(x) max(x)-min(x))


# MAP_*() -- Allows you to specify the type of output
map_dbl(my_list, mean)

  # map_chr(), map_lgl(), ... return vectors

# MAP2() -- Allows you to apply a function to two similar lists (returns a list)
my_list_2 <- list(rnorm(100), runif(10), rgamma(40, shape = 1, rate = 1))
map2(my_list, my_list_2, \(x, y) mean(x)-mean(y))


# PMAP() -- Extends this idea to an arbitrary number of lists
my_list_3 <- list(rnorm(100), runif(10), rgamma(40, shape = 1, rate = 1))
pmap(list(my_list, my_list_2, my_list_3),
     \(x, y, z) (mean(x)-mean(y))/mean(z))


# WALK() -- walk() allows you to use a side-effect function but return the original data

#just apply the function
par(mfrow = c(1, 3))
my_list |>
  map(hist)

par(mfrow = c(1, 3))
#now apply the function but still have the original data
my_list |>
  walk(hist) |>
  map_dbl(mean)



# LIST COLUMNS -- Recall our connection between lists and data frames:
  # Data frame = list of equal length vectors

typeof(iris)
str(iris)

# A list is a vector... if of appropriate length, it can be the column of a data frame!
iris |>
  as_tibble() |>
  mutate(diffs = pmap(list(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
                      \(x, y, z, w) list(x-y, x-z, x-w))) |>
  select(diffs, everything())


iris |>
  as_tibble() |>
  mutate(diffs = pmap(list(Sepal.Length, Sepal.Width, Petal.Length, Petal.Width),
                      \(x, y, z, w) list(x-y, x-z, x-w))) |>
  pull(diffs)


# Note: purrr:pluck() is a helper function for grabbing a named element or by index number
library(httr)
library(jsonlite)
game_info <- GET("https://api-web.nhle.com/v1/score/2024-04-04") |>
  content("text") |>
  fromJSON(flatten = TRUE, simplifyDataFrame = TRUE) |>
  pluck("games")

  # pluck() could be replaced with '[[' ("games")


# Check the tvBroadcasts column!
str(game_info, max.level = 1)

# In this case, our list-column contains a data frame in each list element:
game_info$tvBroadcasts


# We can manipulate list-columns with dplyr::mutate()
# Since elements are lists, we want to use map() functions!
game_info |>
  mutate(num_networks = map(tvBroadcasts, nrow)) |>
  select(num_networks, tvBroadcasts, everything())


# RECAP

# purrr gives us a bit cleaner/more consistent way to apply functions to objects
  # Lots of additional helper functions
  # Use apply() family or purrr to improve your code!





# UNNAMED ARGUMENTS

# Sometimes we want to
  # supply arguments to functions used in the body of our function
  # allow the user to specify more than one argument (say column)

# Consider the first argument of data.frame():
data.frame

# Our standardize() Function -- recall we wrote the follwing function
standardize <- function(vector, center = TRUE, scale = TRUE) {
  mean <- mean(vector)
  stdev <- sd(vector)
  if (center) {
    vector <- vector - mean
  }
  if (scale) {
    vector <- vector / stdev
  }
  return(list(result = vector, mean = mean, sd = stdev))
}


# Add unnamed arguments to our function for use with sd() and mean()
sd
mean.default

standardize <- function(vector, center = TRUE, scale = TRUE, ...) { # now we can add arguments to our fxn
  mean <- mean(vector, ...)
  stdev <- sd(vector, ...)
  if (center) {
    vector <- vector - mean
  }
  if (scale) {
    vector <- vector / stdev
  }
  return(list(result = vector, mean = mean, sd = stdev))
}

# airquality has a column called Ozone with missing values
airquality$Ozone

standard_Ozone <- standardize(airquality$Ozone, na.rm = TRUE) # here we added na.rm = TRUE
standard_Ozone$mean
standard_Ozone$sd

# Note: You can get at the unnamed arguments with list(...)
f <- function(x, ...){
  unnamed <- list(...)
  modifyX <- x^2
  return(list(newX = modifyX, elipses = unnamed))
}
f(x = 10, a = 1, b = list(char = "hey there", num = 1:3))


# Alternatively, just grab the names
f <- function(x, ...){
  unnamed <- names(list(...))
  modifyX <- x^2
  return(list(newX = modifyX, elipses_names = unnamed))
}
f(x = 10, a = 1, b = list(char = "hey there", num = 1:3))



# how can we write functions that take columns of data as arguments in the tidyverse framework?

# Function to find group means
iris |>
  group_by(Species) |>
  summarize(across(where(is.numeric),
                   list("mean" = mean),
                   .names = "{.fn}_{.col}"))


# doesn't work, group argument isn't in df
find_group_mean <- function(.df, group){
  .df |>
    group_by(group) |>
    summarize(across(where(is.numeric),
                     list("mean" = mean),
                     .names = "{.fn}_{.col}"))
}
find_group_mean(iris, Species)


# doesn't work, passing as a string doesn't work either
find_group_mean <- function(.df, group){
  .df |>
    group_by(group) |>
    summarize(across(where(is.numeric),
                     list("mean" = mean),
                     .names = "{.fn}_{.col}"))
}
find_group_mean(iris, "Species")


# Two approaches:
  # enquo() with !!() (injection operator)
  # {{}}

find_group_mean <- function(.df, group){
  group_name <- enquo(group)
  .df |>
    group_by(!!group_name) |>
    summarize(across(where(is.numeric),
                     list("mean" = mean),
                     .names = "{.fn}_{.col}"))
}
find_group_mean(iris, Species)


find_group_mean <- function(.df, group){
  .df |>
    group_by({{group}}) |>
    summarize(across(where(is.numeric),
                     list("mean" = mean),
                     .names = "{.fn}_{.col}"))
}
find_group_mean(iris, Species)


# Combining with ...
  # We can allow for multiple columns with ...
  # Must use quos() and !!!() instead

find_group_mean <- function(.df, ...){
  group_vars <- quos(...)
  .df |>
    group_by(!!!group_vars) |>
    summarize(across(where(is.numeric),
                     list("mean" = mean),
                     .names = "{.fn}_{.col}"))
}
find_group_mean(CO2, Type, Treatment)


# AS_LABEL() for tidyverse StyleFunctions

# We may want to name a variable using a column passed
# as_label() can be used!
# Must use "Walrus" operator, :=

find_group_mean <- function(.df, group, column){   # pass column as argument too
  group_name <- enquo(group)
  column_name <- enquo(column)
  column_label <- paste0("mean_", as_label(column_name))
  .df |>
    group_by(!!group_name) |>
    summarize(!!(column_label) := mean(!!column_name))
}
find_group_mean(iris, Species, Sepal.Length)




# Pipeable functions
  # Example: Side-effect function to print info

print_num_obs <- function(.df) {
  cat("The number of observations in the data set is ",
      nrow(.df),
      "\n",
      sep = "")
}
iris |>
  print_num_obs() |>
  summarize(mean = mean(Sepal.Length))  # the function doesn't retain the data, so summarize doesn't work



print_num_obs <- function(.df) {
  cat("The number of observations in the data set is ",
      nrow(.df),
      "\n",
      sep = "")
  invisible(.df)  # use invisible() to retain the data (invisibly)
}
iris |>
  print_num_obs() |>
  summarize(mean = mean(Sepal.Length))



# R evaluates arguments only when needed!
# Consider the silly function below:
run <- function(x){
  3
}
run(stop("stop now!"))


# Force evaluation by writing the argument or force(arg)
run <- function(x){
  force(x) # or just x, this just makes it explicit it wasn't a typo!
  3
}
run(stop("stop now!"))


# This is true for compound if statements as well!
x <- NULL
x > 0

if(x > 0){
  print("hey")
}

!is.null(x)

if (!is.null(x) && x > 0) {
  print("hey")
}



# Environments and Lexical Scoping

# Don't need to fully understand environments but some things are important

library(rlang)#install if needed., pryr has been retired
where <- function(name, env = caller_env()) {
  if (identical(env, empty_env())) {
    stop("Can't find ", name, call. = FALSE) # Base case
  } else if (env_has(env, name)) {
    env # Success case
  } else {
    where(name, env_parent(env)) # Recursive case
  }
} #taken from https://adv-r.hadley.nz/environments.html
x <- "hey"
where("x")
where("mean")


# When you call a function, it creates temporary function environments
# This is why variables in functions don't overwrite things!

f <- function(x){
  mean <- paste0(x, " is a value")
  mean
}
f(1:3)
mean


# When you call a function, it creates temporary function environments
# This is why variables in functions don't exist outside the function

g <- function(x) {
  if (!exists("a", inherits = FALSE)) {
    message("Defining a")
    a <- 1
  } else {
    a <- a + 1
  }
  a
}
g(10)
g(10)


# When you call a function, it creates temporary function environments
# This is why variables can have the same name in a function and in your global environment

y <- 10
f <- function(x){
  y <- 1
  x + y
}
f(15)


# Important: If R doesn't find an object in the current environment, it will search up the path
  # BAD PRACTICE

y <- 1
f <- function(x){
  x + y
}
f(10)



# R SHINY

library(shiny)
runExample("01_hello")

# The user interface (ui) object controls the layout and appearance of your app. The server function contains the instructions that your computer needs to build your app. Finally the shinyApp function creates Shiny app objects from an explicit UI/server pair.

# Here is the ui part for the example above
library(shiny)
library(bslib)

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Hello Shiny!",
  # Sidebar panel for inputs ----
  sidebar = sidebar(
    # Input: Slider for the number of bins ----
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 1,
      max = 50,
      value = 30
    )
  ),
  # Output: Histogram ----
  plotOutput(outputId = "distPlot")
)

# Here is the server
# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlot <- renderPlot({
    
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#007bc2", border = "white",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
    
  })
  
}

shinyApp(ui = ui, server = server)


# Every Shiny app has the same structure: an app.R file that contains ui and server. You can create a Shiny app by making a new directory and saving an app.R file inside it. It is recommended that each app will live in its own unique directory.

# You can run a Shiny app by giving the name of its directory to the function runApp. For example if your Shiny app is in a directory called my_app, run it with the following code:
library(shiny)
runApp("my_app")


# If you would like your app to display in showcase mode, you can run
runApp("App-1", display.mode = "showcase")


# You can create Shiny apps by copying and modifying existing Shiny apps. The Shiny gallery provides some good examples, or use the eleven pre-built Shiny examples listed below.

runExample("01_hello")      # a histogram
runExample("02_text")       # tables and data frames
runExample("03_reactivity") # a reactive expression
runExample("04_mpg")        # global variables
runExample("05_sliders")    # slider bars
runExample("06_tabsets")    # tabbed panels
runExample("07_widgets")    # help text and submit buttons
runExample("08_html")       # Shiny app built from HTML
runExample("09_upload")     # file upload wizard
runExample("10_download")   # file download wizard
runExample("11_timer")      # an automated timer