
# Widgets
  # all follow this structure:
widgetName("inputId", label = "Title the user sees", ...)

# Widget & TextExample
ui <- fluidPage(
  pageWithSidebar(
    headerPanel('k-Nearest Neighbours Classification'),
    sidebarPanel(
      sliderInput('k', 'Select the Number of Nearest Neighbours', value = 25, min = 1, max = 150),
      checkboxInput('showN', label = "Show the neighbourhood for one point (click to select a point)"),
      a("App credit: https://github.com/schoonees/kNN", href = "https://github.com/schoonees/kNN")
    ),
    mainPanel(
      plotOutput('plot1', width = "600px", height = "600px", click = "click_plot")
    )
  )
)


# Render* Functions
  # These define reactive contexts that allow you to use info from widgets (via input$inputId)

output$plot1 <- renderPlot({...
  ## Fit model
  fit <- knn(train = train,
             test = test,
             cl = trainclass,
             k = input$k,
             prob = TRUE)
  ...
  ## Plot create empty plot
  plot(train, asp = 1, type = "n", xlab = "x1", ylab = "x2",
       xlim = range(pts2), ylim = range(pts2),
       main = paste0(input$k, "-Nearest Neighbours"))
  ...


# Corresponding *Output function goes in the UI
  mainPanel(
    plotOutput('plot1'),
    textOutput('my_text') #goes with output$my_text <- renderText({...}) in server
  )
)


counties <- readRDS("census-app/data/counties.rds")
head(counties)



# Reactive Expressions -- saves its result the first time you run it.

  # The next time the reactive expression is called, it checks if the saved value has become out of date (i.e., whether the widgets it depends on have changed).

  # If the value is out of date, the reactive object will recalculate it (and then save the new result).

  # If the value is up-to-date, the reactive expression will return the saved value without doing any computation.


# When it comes to sharing Shiny apps, you have two basic options:

  # 1. Share your Shiny app as R scripts. This is the simplest way to share an app, but it works only if your users have R on their own computer (and know how to use it). Users can use these scripts to launch the app from their own R session, just like you’ve been launching the apps so far in this tutorial.

  # 2. Share your Shiny app as a web page. This is definitely the most user friendly way to share a Shiny app. Your users can navigate to your app through the internet with a web browser. They will find your app fully rendered, up to date, and ready to go.


# runUrl will download and launch a Shiny app straight from a weblink.

# To use runURL:
  
  # Save your Shiny app’s directory as a zip file

  # Host that zip file at its own link on a web page. Anyone with access to the link can launch the app from inside R by running:

library(shiny)
runUrl( "<the weblink>")


# If you don’t have your own web page to host the files at, you can host your the files for free at www.github.com.

# To share an app through GitHub, create a project repository on GitHub. Then store your app.R file in the repository, along with any supplementary files that the app uses. Your users can launch your app by running:

runGitHub( "<your repository name>", "<your user name>")

# To share your app as a gist:

  # Copy and paste your app.R files to the gist web page.

  # Note the URL that GitHub gives the gist.

# Once you’ve made a gist, your users can launch the app with runGist("<gist number>") where "<gist number>" is the number that appears at the end of your Gist’s web address.

runGist("eb3470beb1c0252bd0289cbc89bcf36f")




# All of the above methods share the same limitation. They require your user to have R and Shiny installed on their computer.

# If you’d prefer an easier experience or need support, Posit (formerly RStudio) offers three ways to host your Shiny app as a web page:

  # shinyapps.io
  # Shiny Server
  # Posit Connect


# The easiest way to turn your Shiny app into a web page is to use shinyapps.io, Posit’s hosting service for Shiny apps.

# shinyapps.io lets you upload your app straight from your R session to a server hosted by Posit. You have complete control over your app including server administration tools. You can find out more about shinyapps.io by visiting shinyapps.io.


# Shiny Server is a companion program to Shiny that builds a web server designed to host Shiny apps. It’s free, open source, and available from GitHub.

# To see detailed instructions for installing and configuring a Shiny Server, visit the Shiny Server guide at https://github.com/rstudio/shiny-server/blob/master/README.md




# If you use Shiny in a for-profit setting, you may want to give yourself the server tools that come with most paid server programs, such as

  # Password authentication
  # SSL support
  # Administrator tools
  # Priority support




