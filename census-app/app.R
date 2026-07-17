library(shiny)

ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = 
        c("Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, 
      max = 100, 
      value = c(0, 100)
    )
  ),
  textOutput("selected_var")
)


# Notice that textOutput takes an argument, the character string "selected_var". Each of the *Output functions require a single argument: a character string that Shiny will use as the name of your reactive element. Your users will not see this name, but you will use it later.

# The server function plays a special role in the Shiny process; it builds a list-like object named output that contains all of the code needed to update the R objects in your app. Each R object needs to have its own entry in the list.

# In the server function below, output$selected_var matches textOutput("selected_var") in your ui.

server <- function(input, output) {
  
  output$selected_var <- renderText({
    "You have selected this"
  })
  
}

shinyApp(ui = ui, server = server)


# Shiny will automatically make an object reactive if the object uses an input value. For example, the server function below creates a reactive line of text by calling the value of the select box widget to build the text.

server <- function(input, output) {
  
  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })
  
}

runApp("census-app")



# Add a second line of reactive text to the main panel of your Shiny app. This line should display “You have chosen a range that goes from something to something”, and each something should show the current minimum (min) or maximum (max) value of the slider widget.



ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices = c("Percent White",
                  "Percent Black",
                  "Percent Hispanic",
                  "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, max = 100, value = c(0, 100)
    )
  ),
  textOutput("selected_var"),
  textOutput("min_max")                         # Add text output
)

server <- function(input, output) {
  
  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })
  
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",   # Render the text output
          input$range[1], "to", input$range[2])
  })
  
}

shinyApp(ui, server)






counties <- readRDS("census-app/data/counties.rds")
head(counties)

# helpers.R is an R script that can help you make choropleth maps, like the ones pictured above. A choropleth map is a map that uses color to display the regional variation of a variable. In our case, helpers.R will create percent_map, a function designed to map the data in counties.rds

# The percent_map function in helpers.R takes five arguments:

# Argument -- Input
  # var -- a column vector from the counties.rds dataset
  # color -- any character string you see in the output of colors()
  # legend.title -- A character string to use as the title of the plot’s legend
  # max -- A parameter for controlling shade range (defaults to 100)
  # min -- A parameter for controlling shade range (defaults to 0)


# You can use percent_map at the command line to plot the counties data as a choropleth map, like this.

library(maps)
library(mapproj)
source("census-app/helpers.R")
counties <- readRDS("census-app/data/counties.rds")
percent_map(counties$white, "darkgreen", "% White")


# When Shiny runs the commands in server.R, it will treat all file paths as if they begin in the same directory as server.R. In other words, the directory that you save server.R in will become the working directory of your Shiny app.

# Since you saved helpers.R in the same directory as server.R, you can ask Shiny to load it with
setwd("/Users/benglickauf/ST558/My_first_repo/census-app")
source("helpers.R")
counties <- readRDS("data/counties.rds")
library(maps)
library(mapproj)

setwd("/Users/benglickauf/ST558/My_first_repo")

shinyApp(ui, server)



# Here’s what we’ve learned so far:

  # The shinyApp function is run once, when you launch your app
  # The server function is run once each time a user visits your app
  # The R expressions inside render* functions are run many times. Shiny runs them once each time a user          changes the value of a widget.




# How can you use this information?

# Source scripts, load libraries, and read data sets at the beginning of app.R outside of the server function. Shiny will only run this code once, which is all you need to set your server up to run the R expressions contained in server.

# Define user specific objects inside server function, but outside of any render* calls. These would be objects that you think each user will need their own personal copy of. For example, an object that records the user’s session information. This code will be run once per user.

# Only place code that Shiny must rerun to build an object inside of a render* function. Shiny will rerun all of the code in a render* chunk each time a user changes a widget mentioned in the chunk. This can be quite often.

# You should generally avoid placing code inside a render function that does not need to be there. Doing so will slow down the entire app.



# YOUR TURN 1

setwd("/Users/benglickauf/ST558/My_first_repo/census-app")

library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")

# User interface ----
ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices =
        c(
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
        ),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0,
      max = 100,
      value = c(0, 100)
    ),
  ),
  card(plotOutput("map"))
)

# Server logic ----
server <- function(input, output){
  output$map <- renderPlot({
    percent_map(...)
})
}

# Run app ----
shinyApp(ui, server)


# You may wonder, “Won’t each user need their own copy of counties and percent_map?” (which would imply that the code should go inside of the server function). No, each user will not.

# Keep in mind that your user’s computer won’t run any of the R code in your Shiny app. In fact, their computer won’t even see the R code. The computer that you use as a server will run all of the R code necessary for all of your users. It will send the results over to your users as HTML elements.

# Your server can rely on a single global copy of counties.rds and percent_map to do all of the R execution necessary for all of the users. You only need to build a separate object for each user if the objects will have different values for each of your users.



# MY TURN 2

# Load packages ----
library(shiny)
library(maps)
library(mapproj)

# Load data ----
counties <- readRDS("data/counties.rds")

# Source helper functions -----
source("helpers.R")

# User interface ----
ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices =
        c(
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
        ),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0,
      max = 100,
      value = c(0, 100)
    )
  ),
  card(plotOutput("map"))
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)


setwd("/Users/benglickauf/ST558/My_first_repo")



