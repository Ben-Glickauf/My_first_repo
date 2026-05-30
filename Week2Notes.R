
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




