
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



