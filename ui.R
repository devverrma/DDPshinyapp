library(shiny)

shinyUI(fluidPage(
  titlePanel("Car Fuel Efficiency Predictor"),
  sidebarLayout(
    sidebarPanel(
      h4("Describe your car"),
      sliderInput("wt", "Weight (1000 lbs):", min = 1.5, max = 5.5, value = 3, step = 0.1),
      sliderInput("hp", "Horsepower:", min = 50, max = 340, value = 150, step = 5),
      radioButtons("am", "Transmission:", choices = c("Automatic" = 0, "Manual" = 1), selected = 0),
      checkboxInput("showFit", "Show model fit line on plot", value = TRUE),
      numericInput("km", "Monthly distance driven (km):", value = 1000, min = 0, step = 100),
      numericInput("price", "Fuel price per litre:", value = 105, min = 0, step = 1)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Prediction",
                 h3("Predicted fuel efficiency"),
                 h2(textOutput("mpg")),
                 h4(textOutput("kmpl")),
                 h4(textOutput("cost")),
                 plotOutput("plot")),
        tabPanel("Documentation",
                 h3("How to use this app"),
                 p("This app predicts a car's fuel efficiency (miles per gallon) and your monthly fuel cost."),
                 tags$ol(
                   tags$li("Use the Weight slider to set your car's weight in thousands of pounds."),
                   tags$li("Use the Horsepower slider to set the engine power."),
                   tags$li("Pick Automatic or Manual transmission."),
                   tags$li("Enter how many kilometres you drive per month and the local fuel price per litre."),
                   tags$li("Tick or untick the checkbox to show or hide the model fit line on the plot.")
                 ),
                 p("Results update automatically on the Prediction tab: predicted MPG, the same value in km per litre, and your estimated monthly fuel cost."),
                 h4("How it works"),
                 p("The server fits a linear regression on the built-in mtcars dataset: mpg ~ wt + hp + am. Your inputs are passed to predict() to get the estimate. The plot shows all 32 cars in mtcars (MPG against weight) and your car as a red point."),
                 p("Note: mtcars covers 1973-74 cars, so treat the numbers as an illustration rather than a precise estimate for modern cars."))
      )
    )
  )
))
