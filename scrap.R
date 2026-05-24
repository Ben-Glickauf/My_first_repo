head(iris)

help("seq")
seq(1,9,by=2)

letters

head(cars, n=3)

data()

iris <- iris

class(cars) #2D structure
class(iris)
class(exp). #e^x

plot(cars)
plot(exp)

vec <- c(1,2,3)
vec
class(vec)
summary(vec)

fit <- lm(dist ~ speed, data = cars)
fit
class(fit)
summary(fit)

typeof(cars)
typeof(vec)

str(cars) # same as environment tab
str(vec)

help(hist)

pl <- iris$Petal.Length
typeof(pl)
str(pl)
summary(pl)
class(pl)
is.vector(pl)
hist(pl, main = "Histogram of Petal Length")

cat("Hi my name is Ben. \nI'm a student at NC State.")

getwd()
setwd("/Users/benglickauf/ST558")
getwd()
setwd("/Users/benglickauf")
getwd()









