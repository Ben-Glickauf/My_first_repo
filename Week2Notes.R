
### Vectors 

c(TRUE, "hat", 3)
c(c(TRUE, 3), "hat")  # note the diplay of logical expression


seq(from = 1, to = 10, by = 2)
seq(1, 10, length = 5)

20:30/2
1:15*3

# random uniform number generator
runif(4, min = 0, max = 1)
runif(10)
runif(5, 20, 30)


# R objects can have attributes associated with them. 
# The main attribute that a vector might have associated with it are names for the elements.

u <- c("a" = 1, "b" = 2, "c" = 3)
u
attributes(u)
names(u)


letters
letters[1]
letters[c(5, 10, 15, 20, 25)]
x <- c(1, 2, 5)
letters[x]
letters[-(1:4)]

u
u["a"]
u[c("a", "c")]



### Factors

pets <- c("cat", "dog", "bird", "cat", "other", "bird", "bird", "other", "dog")
pets_factor <- factor(pets,
                      levels = c("cat", "dog", "bird", "rodent", "other"))
pets_factor

str(pets_factor)

pets_factor[1] <- "parrot"

# with labels
pets_factor <- factor(pets,
                      levels = c("cat", "dog", "bird", "rodent", "other"),
                      labels = c("Cat", "Dog", "Bird", "Rodent", "Others"))
pets_factor


pets_factor <- as.factor(pets)
pets_factor
attributes(pets_factor)
levels(pets_factor)
levels(pets_factor) <- c(levels(pets_factor), "rodent")
levels(pets_factor)


### Matrices
# matrices are homogeneous (all elements must be the same type)

matrix(data = NA, 
       nrow = 1, 
       ncol = 1, 
       byrow = FALSE,
       dimnames = NULL)

my_mat <- matrix(c(1, 3, 4, -1, 5, 6), 
                 nrow = 3, 
                 ncol = 2)
my_mat

my_mat <- matrix(c(1, 3, 4, -1, 5, 6), 
                 nrow = 3, 
                 ncol = 2,
                 byrow = TRUE)
my_mat


#populate vectors
x <- rep(0.2, times = 6)
y <- c(1, 3, 4, -1, 5, 6)

str(x)
is.numeric(x)
str(y)
is.numeric(y)
length(x)
length(y)

my_mat2 <- matrix(c(x, y), ncol = 2)
my_mat2

as.vector(my_mat2)

x <- c("Hi", "There", "!")
y <- c("a", "b", "c")
z <- c("One", "Two", "Three")
matrix(c(x, y, z), nrow = 3)

matrix(c(x, y, z), ncol = 2)

matrix(0, nrow = 2, ncol = 2)


my_iris <- as.matrix(iris[, 1:4])
head(my_iris)
str(my_iris)
attributes(my_iris)
dim(my_iris)
dimnames(my_iris)

dimnames(my_iris) <- list(
  1:150, #first list element is a vector for the row names
  c("Sepal Length", "Sepal Width", "Petal Length", "Petal Width") #second element is a vector for column names
)
head(my_iris)



my_mat3 <- matrix(c(runif(10), 
                    rnorm(10),
                    rgamma(10, shape = 1, scale = 1)),
                  ncol = 3,
                  dimnames = list(1:10, c("Uniform", "Normal", "Gamma")))
my_mat3


mat <- matrix(c(1:4, 20:17), ncol = 2)
mat
mat[2, 2]
mat[ , 1]
mat[1,]
mat[2:4, 1]
mat[c(2, 4), ]



#If you do have dimnames associated, then you can access elements with those.
mat <- matrix(c(1:4, 20:17), ncol = 2,
              dimnames = list(NULL,
                              c("First", "Second"))
)
mat

mat[, "First"]



### Arrays
#Arrays are the n-dimensional extension of matrices. Like matrices, they must have all elements of the same type.



my_array <- array(1:24, dim = c(4, 2, 3))
my_array

my_array[1, 1, 1]
my_array[4, 2, 3]


### Data Frames
#These are 2D objects where the columns can be of different types!

x <- c("a", "b", "c", "d", "e", "f")
y <- c(1, 3, 4, -1, 5, 6)
z <- 10:15
my_df <- data.frame(x, y, z)
my_df


str(my_df)
attributes(my_df)
data.frame(1:5, c("a", "b", "c", "d", "e"))


#We can set the names explicitly when we create the data frame.
x <- c("a", "b", "c", "d", "e", "f")
y <- c(1, 3, 4, -1, 5, 6)
z <- 10:15
my_df <- data.frame(char = x, data1 = y, data2 = z)
my_df

data.frame(number = 1:5, letter = c("a", "b", "c", "d", "e"))


## Accessing Elements in a Data Frame

str(iris)
iris[1:4, 2:4] #returns a data frame
iris[1, ] #returns a data frame

iris[1:10, 1] #returns a vector
iris[1:10, 1, drop = FALSE] #return a data frame

`[`(iris, 1:10, 1, drop = FALSE)


# Usually data frames have meaningful column names. We can use these for subsetting
iris[1:5 , c("Sepal.Length", "Species")]
iris$Sepal.Length



### Lists

my_df <- data.frame(number = 1:5, letter = c("a", "b", "c", "d", "e"))
my_list <- list(my_df, rnorm(4), c("!", "?"))
my_list

# we can add names to the list elements upon creation
my_list <- list(my_data_frame = my_df, normVals = rnorm(4), punctuation = c("!", "?"))
my_list

## Common Attributes of Lists
str(my_list)
attributes(my_list)
names(my_list)


## Accessing List Elements
my_list
my_list[2:3]


# Use double square brackets [[ ]] (or [ ]) for a single list element
my_list[1]
my_list[[1]]

# [ ] returns a list with a named element (my_data_frame)
# [[ ]] returns just the element itself (the data frame)

str(my_list[1])
str(my_list[[1]])

my_list[[2]]
my_list[[2]][3:4]

str(my_list)
my_list$normVals
attributes(my_list)
attributes(my_list)$names

## Lists and Data Frames
# Big Connection: A Data Frame is a list of equal length vectors!
# This can be seen in the similar nature of the structure of these two objects.

str(my_list)
is.list(my_list)
str(iris)
is.list(iris)
head(iris[2])
head(iris[[2]])

# Notice again the change in simplification between the two methods for accessing list elements. 
# Think of [ ] as preserving and [[ ]] as simplifying!

typeof(my_list)
typeof(iris)




### Logical Statements

#Strings must be exactly the same to be equivalent
"hi" == "hi"
"hi" == " hi"
4 >= 1
4 != 1
sqrt(3)^2  == 3

# That last one should be true! The issue is the loss of precision with taking the square root of 3. 
# Instead of using == we can use the near() function from the dplyr package 
# (you may need to install this package, install.packages("dplyr")). To call a function directly from a package we can use ::

dplyr::near(sqrt(3)^2, 3)

is.numeric("Word")
is.numeric(c(10, 12, 20))
is.character(c(10, 12, 20))
is.character(c("10", "12"))
is.na(c(1:2, NA, 3))

# This last one is important!
# First, note that R applies the is.na() function element-wise to the vector. This is not common behavior.
# Second, NA is the missing value indicator in R. When we start to read in data we need to check for missing values. More on that later.
# NA differs from NULL which is the undefined value in R


## Logical Statements for Subsetting Data

head(iris)
iris$Species == 'setosa'
iris[iris$Species == "setosa", ]

## Compound Logical Statements

(iris$Petal.Length > 1.5) & (iris$Species == "setosa")
iris[(iris$Petal.Length > 1.5) & (iris$Species == "setosa"), ]
iris[((iris$Petal.Length > 1.5) | (iris$Petal.Width < 0.15)) & (iris$Species == "setosa"), ]


## Quick Aside on Implicit Coercion

#coerce numeric to string
c("hi", 10)

#coerce TRUE/FALSE to numeric
c(TRUE, FALSE) + 0
c(TRUE, FALSE) + 10

as.numeric(c(TRUE, FALSE, TRUE))
mean(c(TRUE, FALSE, TRUE))


# The order of coercion (from least flexible to most)
  # logical
  # integer
  # double
  # character


## Conditional Execution


if (condition) {
  # then execute code
} 

#if then else
if (condition) {
  # execute this code  
} else {
  # execute this code
}

#Or more if statements
if (condition) {
  # execute this code  
} else if (condition2) {
  # execute this code
} else if (condition3) {
  # execute this code
} else {
  #if no conditions met
  # execute this code
}


# Note! You should keep the { on the lines as you see here

head(airquality)
airquality$Wind[1]

if(airquality$Wind[1] >= 15) { 
  "High Wind"
} else if (airquality$Wind[1] >= 10){
  "Windy"
} else if (airquality$Wind[1] >= 6) {
  "Light Wind"
} else if (airquality$Wind[1] >= 0) {
  "Calm"
} else {
  "Error"
}


### Loops

## For loops

for(index in values){
  # code to be run
}

for (i in 1:10){
  print(i)
}


for (index in c("cat","hat","worm")){
  print(index)
}


words<-c("first", "second", "third", "fourth", "fifth")
data <- runif(5)

# Loop through the elements of these and print out the phrase “The (#ed) data point is (# from data vector).”

# To put character strings together with other R objects (which will be coerced to strings) we can use the paste() function. 

paste("The ", words[2], " data point is ", data[2], ".", sep = "&")
paste("The ", words[1], " data point is ", data[1], ".", sep = "")

# Note: sep = "" is equivalent to using the paste0() function.

for (i in 1:5){
  print(paste0("The ", words[i], " data point is ", data[i], "."))
}

#install.packages("Lahman")
library(Lahman)
my_batting <- Batting[, c("playerID", "teamID", "G", "AB", "R", "H", "X2B", "X3B", "HR")]
head(my_batting)


#Let’s say we want to find the summary() for each numeric column of this data set.
summary(my_batting[ , "G"])
summary(my_batting[ , "AB"])

#That’s fine but we want to do it for all the numeric columns. Let’s use a for loop!
dim(my_batting)

#We could do a loop that takes on values of 3:9 (or programmatically 3:dim(my_batting)[2]).

for (i in 3:dim(my_batting)[2]){
  print(summary(my_batting[ , i]))
}

# Alternatively, the seq_along() function can be useful. This looks at the length of the object and creates a sequence from 1 to that length. Remember that a data frame is truly a list of equal length vectors (usually). The length of a list is number of elements. Here that is the number of columns!

length(my_batting)
seq_along(my_batting)

#Now we can just remove the 1st and 2nd entries of that vector (as they are not numeric columns) and use that as our values to iterate across.

for (i in seq_along(my_batting)[-1:-2]){
  print(summary(my_batting[ , i]))
}

# We likely don’t enjoy this format. Although we’ll see much easier ways to deal with this, let’s initialize a data frame to store our results in. We can initialize the type of data to store in a particular column using character(), numeric(), logical(), etc.

summary_df <- data.frame(stat = character(), 
                         min = numeric(),
                         Q1 = numeric(),
                         Median = numeric(),
                         Mean = numeric(),
                         Q3 = numeric(),
                         Max  = numeric())
summary_df


# Ok, now let’s fill this in as we loop (note we use i-2 to start filling in at row 1 and we grab the statistic we are summarizing from the colnames of the my_batting data frame).

for (i in seq_along(my_batting)[-1:-2]){
  summary_df[i-2, ] <- c(colnames(my_batting[i]),
                         summary(my_batting[ , i]))
}
summary_df


## While Loops

while(cond) {
  expr
}


## Other Loop Things


#Sometimes we need to jump out of a loop. break kicks you out of the loop.

for (i in 1:5){
  if (i == 3) break #can put code to execute on the same line
  print(paste0("The ", words[i], " data point is ", data[i], "."))
}


#Sometimes we need to skip an iteration. next jumps to the next iteration of the loop.

for (i in 1:5){
  if (i == 3) next
  print(paste0("The ", words[i], " data point is ", data[i], "."))
}


### Vectorized Functions

library(Lahman)
my_batting <- Batting[, c("playerID", "teamID", "G", "AB", "R", "H", "X2B", "X3B", "HR")]
head(my_batting)

colMeans(my_batting[, 3:9])

#If we install the matrixStats package (download the files from the internet), we can then use the colMedians() function to obtain the column medians in a quick fashion.

#install.packages("matrixStats") #only run this once on your machine!
library(matrixStats)
colMedians(my_batting[, 3:9])

colMedians(as.matrix(my_batting[, 3:9]))


#Let’s compare the speed of this code to the speed of a for loop!
  # The microbenchmark package allows for easy recording of computing time.
  # We just wrap the code we want to benchmark in the microbenchmark() function.
  # This repeatedly executes the code and reports summary stats on how long it took

#install.packages("microbenchmark") #run only once on your machine!
library(microbenchmark)
my_numeric_batting <- Batting[, 6:22] #get all numeric columns
vectorized_results <- microbenchmark(
  colMeans(my_numeric_batting, na.rm = TRUE)
)

loop_results <- microbenchmark(
  for(i in 1:17){
    mean(my_numeric_batting[, i], na.rm = TRUE)
  }
)

vectorized_results
loop_results


## Vectorized ifelse

ifelse(vector_condition, if_true_do_this, if_false_do_this)

ifelse(airquality$Wind >= 15, "HighWind", "Not HighWind")

#We can use a second call to ifelse() to assign what to do in the FALSE condition!
ifelse(airquality$Wind >= 15, "HighWind",
       ifelse(airquality$Wind >= 10, "Windy",
              ifelse(airquality$Wind >= 6, "LightWind", 
                     ifelse(airquality$Wind >= 0, "Calm", "Error"))))

# Let’s compare this to using a for loop speed-wise.

loopTime<-microbenchmark(
  for (i in seq_len(nrow(airquality))){
    if(airquality$Wind[i] >= 15){
      "HighWind"
    } else if (airquality$Wind[i] >= 10){
      "Windy"
    } else if (airquality$Wind[i] >= 6){
      "LightWind"
    } else if (airquality$Wind[i] >= 0){
      "Calm"
    } else{
      "Error"
    }
  }
  , unit = "us")

vectorTime <- microbenchmark(
  ifelse(airquality$Wind >= 15, "HighWind",
         ifelse(airquality$Wind >= 10, "Windy",
                ifelse(airquality$Wind >= 6, "LightWind", 
                       ifelse(airquality$Wind >= 0, "Calm", "Error"))))
)

loopTime
vectorTime


### Writing Functions

nameOfFunction <- function(input1, input2, ...) {
  #code
  #return something with return()
  #or the function returns last thing done
}

#One nice thing is that you can generally look at the code for the functions you use by typing the function without () into the console.

var
# Unless the if statements cause the function to stop, the result of .Call(C_cov, x, y, na.method, FALSE) is returned.

colMeans
# Unless the if statements cause the function to stop, z is the last code run and is what gets returned.

# For some functions, they are generic and they won’t show anything useful.
mean
mean.default


# Goal: Create a standardize() function (creating z-scores for a vector essentially)

standardize <- function(vector) {
  return((vector - mean(vector)) / sd(vector))
}


set.seed(10)
data <- runif(15)
data

result <- standardize(data)
result

mean(result)
sd(result)


# Goal: Add more inputs
  # Make centering optional
  # Make scaling optional

standardize <- function(vector, center, scale) {
  if (center) {
    vector <- vector - mean(vector)
  }
  if (scale) {
    vector <- vector / sd(vector)
  }
  return(vector)
}

# Here we’ve added arguments that should implicitly be TRUE or FALSE values (it would be better to give a default value so people using the function would know what is expected).

result <- standardize(data, center = TRUE, scale = TRUE)
result

result <- standardize(data, center = FALSE, scale = TRUE)
result


# Give center and scale default arguments

standardize <- function(vector, center = TRUE, scale = TRUE) {
  if (center) {
    vector <- vector - mean(vector)
  }
  if (scale) {
    vector <- vector / sd(vector)
  }
  return(vector)
}

standardize(data, center = TRUE, scale = TRUE)
standardize(data)


# Goal: Also return
  # mean() of original data
  # sd() of original data

# Return more than 1 object by returning a list (so we return one object, but a very flexible object that easily contains other objects!)

standardize <- function(vector, center = TRUE, scale = TRUE) {
  mean <- mean(vector) #save these so we can return them
  stdev <- sd(vector)
  if (center) {
    vector <- vector - mean
  }
  if (scale) {
    vector <- vector / stdev
  }
  return(list(vector, mean, stdev))
}

result <- standardize(data)
result 
result[[2]]

# We can fancy up what we return by giving names to the list elements!

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

result <- standardize(data, center = TRUE, scale = TRUE)
result  
result$sd


## stop() and switch()

# Often you want to check on inputs to make sure they are of the right form (that’s good practice if you are going to share your code). You can use if() or switch() to do this check.


# Here we’ll write a function to create a summary (mean, median, or trimmed mean).

  # First we check the input to make sure it is a numeric vector.
  # Then we use stop() to jump out if that condition isn’t met.
  # If the condition is met, we use switch() an alternative to if/then/else to pick which function to apply.


summarizer <- function(vec, type, trim = 0.05) {
  if(!is.vector(vec) | !is.numeric(vec)){
    stop("Not a vector or not numeric my friend.")
  }
  switch(type, 
         mean = mean(vec),
         median = median(vec),
         trimmed = mean(vec, trim),
         stop("Mistake!")
  )
}

summarizer(letters, "mean")
summarizer(c(1,1,1,6,10), "mean")
summarizer(c(1,1,1,6,10), "trimmed", 0.2)
summarizer(c(1,1,1,6,10), "means")


## Naming conventions

# When we write functions and create objects we should try to follow this advice:

  # Functions named using verbs
    # standardize() or find_mean() or renderDataTable()

  # Data objects named using nouns
    # my_df or weather_df


## Input Matching

# You might wonder why sometimes we name our arguments when we call our functions and sometimes we don’t. Generally, we don’t name the first 2-3 arguments but name ones after that. However, that is just convention. In R, you can use positional matching for everything or name each input, or combine the two ideas!


# Let’s look at some examples. Consider the inputs of the cor() function

# function(x, y = NULL, use = "everything", method = c("pearson", "kendall", "spearman"))
  
# Apply it to iris data using positional matching (first argument to x second to y):

cor(iris$Sepal.Length, iris$Sepal.Width)


# R will use positional matching for all inputs not explicitly named. Here it applies iris$Sepal.Width to the first input of the function that wasn’t specified, here y.

cor(x = iris$Sepal.Length, method = "spearman", iris$Sepal.Width)

# R will also do partial matching but you should avoid this generally.

cor(iris$Sepal.Length, iris$Sepal.Width, met = "spearman")


## Infix functions

# Lastly, let’s take up the idea of an infix function. An infix function is a function that goes between arguments (as opposed to prefix that goes prior to the arguments - which is what we usually do).

mean(3:5) #prefix
3 + 5 #+ is infix
`+`(3, 5) #used as a prefix function

# Common built-in infix functions include:
  
  #  :: (look directly in a package for a function)
  #  $ (grab a column)
  #  ^
  #  *
  #  /
  #  +
  #  -
  #  >
  #  >=
  #  <
  #  <=
  #  ==
  #  !=
  #  & (and)
  #. | (or)
  #  <- (storage arrow)
  #. |> (pipe!)

cars <- as.matrix(cars)
t(cars) %*% cars

`%*%`(t(cars), cars)

`%+%` <- function(a, b) paste0(a, b)
"new" %+% " string"

# R actually allows you to overwrite + and other operators: just don’t do that… that wouldn’t be good (unless you really want to mess with someone)

x <- y <- 2
`<-`(x, `<-`(y, 2)) #interpretation of above code!

x <- y = 2# error! <- has higher precedence
`=`(`<-`(x, y), 2) #interpretation of above code!

x = y <- 2 # this will work!
`=`(x, `<-`(y, 2)) #interpretation of above code!



`%-%` <- function(a, b) {
  paste0("(", a, " %-% ", b, ")")
}
"a" %-% "b" %-% "c" #user defined infix are evaluated left to right!

`%-%`(`%-%`("a", "b"), "c")  #interpretation of above code!

x <- y <- 2
`<-`(x, `<-`(y, 2)) #interpretation of above code!


## Base R Pipe

# This one deserves its own section! The pipe operator (%>%) was made popular by the tidyverse and the magrittr package. You would need to read in dplyr (part of the tidyverse) or magrittr to have access to the pipe.

# Due to the popularity, R created a Base R pipe (|>). The idea of the pipe is to make code more readable! Essentially, you can read code left to right when using a pipe instead of inside out.

library(dplyr)
arrange(select(filter(as_tibble(Lahman::Batting), teamID == "PIT"), playerID, G, X2B), desc(X2B))


# Forget what the functions do for a minute. To parse this we need to start on the inside.

  # The first function is as_tibble(Lahman::Batting)
  # The result of that is then the first argument to filter()
  # The result of this is then the first argument to select()
  # The result of that is then the first argument to arrange()

# Yikes. Piping makes things way easier to read!

Lahman::Batting |> #read the pipe as "then"
  as_tibble() |>
  filter(teamID == "PIT") |>
  select(playerID, G, X2B) |> 
  arrange(desc(X2B)) 


# Generically, |> does the following
  
  # x |> f(y) turns into f(x,y)
  # x |> f(y) |> g(z) turns into g(f(x, y), z)

