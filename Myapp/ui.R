library(shiny)
library(plotly)
shinyUI(fluidPage(
    titlePanel("Main Stock Indices in Global Financial Market"),
    sidebarLayout(
        sidebarPanel(
          
            h3("Select Area"),
            selectInput("Area", "Area:", 
                        c("America", "Europe","China" ))
        ),
        
        mainPanel(
            plotOutput("Index_plot"),
            plotOutput("Volatility_plot")
        )
    )
))
