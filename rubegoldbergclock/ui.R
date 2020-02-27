#' 
#' This is the user-interface definition of the Shiny web application
#' for the Rube Goldberg Clock. 
#' 
#' You can run the application by clicking 'Run App' above.
#'

library(shiny)
library(shinyjs)
library(shinyalert)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
    # Documentation/Instructions
    useShinyalert(),  # Set up shinyalert
    actionButton("instr", "Supporting Documentation"),
    
    # Application title
    titlePanel("Rube Goldberg Clock"),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            useShinyjs(),
            sliderInput("light",
                        "How bright is it?",
                        min = 1,
                        max = 5,
                        value = 30),
            sliderInput("loud",
                        "How loud it it?",
                        min = 1,
                        max = 5,
                        value = 30),
            sliderInput("hunger",
                        "How hungry are you?",
                        min = 1,
                        max = 5,
                        value = 30),
            sliderInput("sleep",
                        "How sleepy are you?",
                        min = 1,
                        max = 5,
                        value = 30),
            selectInput("giventime",
                        "Do you know the time?",
                        c("Yes" = "yes", "NO!" = "no"))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("clockat", width = "600px"),
            tags$script('
          $(document).ready(function(){
          var d = new Date();
          var target = $("#clientTime");
          target.val(d.toLocaleString());
          target.trigger("change");
          });
          '),
            shinyjs::hidden(textInput("clientTime", "Client Time", value = "")),
            h2(textOutput("currentTime")),
            "Disclaimer: This clock tells the time accurately within 6 hours of the actual time. It gives no meridiem information.")
            
        ),
    
    selectInput('website', 'To see the R code on Github, choose:'
                , list(server.R = "https://github.com/nairarshad/ddpw4/blob/gh-pages/rubegoldbergclock/server.R"
                       , ui.R = "https://github.com/nairarshad/ddpw4/blob/gh-pages/rubegoldbergclock/ui.R"
                       , repository = "https://github.com/nairarshad/ddpw4/"
                       , Rpresentation = "https://nairarshad.github.io/ddpw4/")
    ), strong("Click Me:"), htmlOutput("mySite")
    
    
    
    )
    )

