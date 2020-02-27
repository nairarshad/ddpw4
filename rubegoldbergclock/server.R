#'
#' This is the server logic of the Shiny web application
#' Rube Goldberg Clock. 
#' 
#' You can run the application by clicking 'Run App' above.
#'

library(shiny)
library(grid)
library(randomForest)
library(lubridate)
library(shinyalert)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    # Link to Github code
    output$mySite <- renderUI({
        tags$a(href = input$website, input$website)
    })
    
    # Instructions/Documentation popup
    observeEvent(input$instr, {
        # Show a modal when the button is pressed
        shinyalert("", "This is a fun Shiny App that tries to guess the time based on your state. This guess is from a random forest classification model for the hour and a random number for the minutes. 
                   
                   If you don't know the time, choose \"NO!\" for the last question and mark the intensity you feel for the other questions in the sidebar; sit back, and let the random forest tell you the time :P", type = "info")
    })
    
    #' drawClock function to draw a clock
    #' Adapted from https://www.stat.auckland.ac.nz/~paul/RG2e/interactive-clock.R
    drawClock <- function(hour, minute) {
        t <- seq(0, 2*pi, length=13)[-13]
        x <- cos(t)
        y <- sin(t)
        
        grid.newpage()
        pushViewport(dataViewport(x, y, gp=gpar(lwd=4)))
        # Circle with ticks
        grid.circle(x=0, y=0, default.units="native", 
                    r=unit(1, "native"))
        grid.segments(x, y, x*.9, y*.9, default.units="native")
        # Hour hand
        hourAngle <- pi/2 - (hour + minute/60)/12*2*pi
        grid.segments(0, 0, 
                      .6*cos(hourAngle), .6*sin(hourAngle), 
                      default.units="native", gp=gpar(lex=4))
        # Minute hand
        minuteAngle <- pi/2 - (minute)/60*2*pi
        grid.segments(0, 0, 
                      .8*cos(minuteAngle), .8*sin(minuteAngle), 
                      default.units="native", gp=gpar(lex=2))    
        grid.circle(0, 0, default.units="native", r=unit(1, "mm"),
                    gp=gpar(fill="white"))
    }
    
    # If the user knows the time
    knowsthetime <- function(x){
        
        hour <- as.integer(substr(x,1,2))
        minute <- as.integer(substr(x,4,5))
        drawClock(hour, minute)
        
    }
    
    #' If the user doesn't know the time
    #' The function trains a random random forest model
    #' and predicts the time from the state of the individual
    unknowntime <- function(light, loud, hunger, sleep){
        trainer <- read.csv("train.csv")
        tester <- data.frame(light = light,	loud = loud, hunger = hunger, sleep = sleep)
        rf <- randomForest(factor(hora) ~ ., data = trainer)
        hhvar <- as.numeric(predict(rf, tester))
        mmvar <- sample(1:60,1)
        drawClock(hhvar,mmvar)
        
    }
    
    #' The actual time
    session$userData$time <- reactive({format(lubridate::mdy_hms(as.character(input$clientTime)), "%H:%M")})
    output$currentTime <- renderText({c("Your time:", session$userData$time())})
    
    #' The output time
    output$clockat <- renderPlot({
        
        light <- input$light
        loud <- input$loud
        hunger <- input$hunger
        sleep <- input$sleep
        timchar <- format(lubridate::mdy_hms(as.character(input$clientTime)), "%H:%M")
        giventime <- input$giventime
        
        ifelse(giventime == "yes", knowsthetime(timchar), unknowntime(light, loud, hunger, sleep))
        
        
    })
    
    
   
    
})
