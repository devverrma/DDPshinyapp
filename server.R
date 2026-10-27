library(shiny)

model <- lm(mpg ~ wt + hp + am, data = mtcars)

shinyServer(function(input, output) {
  
  predictedMpg <- reactive({
    newCar <- data.frame(wt = input$wt, hp = input$hp, am = as.numeric(input$am))
    max(predict(model, newdata = newCar), 1)
  })
  
  kmPerLitre <- reactive({
    predictedMpg() * 0.425144
  })
  
  output$mpg <- renderText({
    paste(round(predictedMpg(), 1), "miles per gallon")
  })
  
  output$kmpl <- renderText({
    paste("=", round(kmPerLitre(), 1), "km per litre")
  })
  
  output$cost <- renderText({
    litres <- input$km / kmPerLitre()
    paste("Estimated monthly fuel cost:", round(litres * input$price, 0))
  })
  
  output$plot <- renderPlot({
    plot(mtcars$wt, mtcars$mpg, pch = 16, col = "grey50",
         xlab = "Weight (1000 lbs)", ylab = "Miles per Gallon",
         main = "Your car vs the mtcars dataset", xlim = c(1.5, 5.5), ylim = c(0, 40))
    if (input$showFit) {
      weights <- seq(1.5, 5.5, by = 0.1)
      fitLine <- predict(model, newdata = data.frame(wt = weights, hp = input$hp,
                                                     am = as.numeric(input$am)))
      lines(weights, fitLine, col = "steelblue", lwd = 2)
    }
    points(input$wt, predictedMpg(), pch = 19, col = "red", cex = 2.5)
    legend("topright", legend = c("mtcars cars", "Your car"),
           col = c("grey50", "red"), pch = c(16, 19))
  })
})