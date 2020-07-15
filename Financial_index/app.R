library(shiny)
library(readxl)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(lubridate)


# Load the data
DJI <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))
NAS <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History_20200713_1152.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))
CSI300 <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Shanghai Shenzhen CSI 300 Index.xlsx",
                     col_types = c("date","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric"))
SSEC <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Shanghai SE Composite Index .xlsx",
                   col_types = c("date","numeric","numeric","numeric"
                                 ,"numeric","numeric","numeric","numeric","numeric"))
FTSE100 <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/FTSE 100 Index.xlsx",
                      col_types = c("date","numeric","numeric","numeric"
                                    ,"numeric","numeric","numeric","numeric","numeric"))
FTSE250 <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/FTSE 250.xlsx",
                      col_types = c("date","numeric","numeric","numeric"
                                    ,"numeric","numeric","numeric","numeric"))
CAC40 <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History_20200714_1335.xlsx",
                    col_types = c("date","numeric","numeric","numeric"
                                  ,"numeric","numeric","numeric","numeric","numeric"))
DAX <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History_20200714_1333.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric","numeric"))
#Data Pre-processing
## US
price_index_US<- merge(DJI%>%select(`Exchange Date`,Close),
                       NAS%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_US<- price_index_US%>%rename(Nasdaq=Close.x ,DJI=Close.y)


## China
price_index_China<- merge(CSI300%>%select(`Exchange Date`,Close),
                          SSEC%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_China<- price_index_China%>%rename(CSI300=Close.x ,SSEC=Close.y)


## Europe
price_index_Eng<- merge(FTSE100%>%select(`Exchange Date`,Close),
                        FTSE250%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_Eng<- price_index_Eng%>%rename(FTSE100=Close.x ,FTSE250=Close.y)

price_index_FG<- merge(CAC40%>%select(`Exchange Date`,Close),
                       DAX%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_FG <- price_index_FG%>%rename(CAC40=Close.x ,DAX=Close.y)
price_index_EU <-  merge(price_index_Eng,price_index_FG,by="Exchange Date")



##Merge all data

price_index1<- merge(price_index_US,price_index_China,by="Exchange Date")
price_index <- merge(price_index1,price_index_EU,by="Exchange Date")

price_index <- price_index %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
    mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_US <- price_index_US %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
    mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_EU <- price_index_EU %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
    mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_China <- price_index_China %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
    mutate_at(vars(`Exchange Date`), funs(year, month))

# Define UI for application that draws a plot
ui <- fluidPage(

    # Application title
    titlePanel(title = h2("Main Stock Indices(USD) in Different Areas", align="center")),
    br(),       br(),
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            #------------------------------------------------------------------
            #Add radio putton to choose for the area of the stock indices
            radioButtons("Area",
                         label = "Select area:",
                         choices = list("North American Indices"='price_index_US',
                                        "Chinese Indices"='price_index_China',
                                        "European Indices"='price_index_EU',
                                        "Global Indices"='price_index'),
                         selected = 'price_index'),
            br(),   br(),
            #------------------------------------------------------------------
            # Add Variable for Year Selection
            sliderInput("YearRange", "Select Year Range : ", min=2006, max=2020, 
                        value=c(2006, 2020), step=1),           
            br(),   br(),
            #------------------------------------------------------------------
        ),

        # design the mainpanel
        mainPanel(
            #------------------------------------------------------------------
            # Create tab panes
            tabsetPanel(type="tab",
                        tabPanel("Summary",verbatimTextOutput("sumry")),
                        tabPanel("Structure", verbatimTextOutput("struct")),
                        tabPanel("Data", tableOutput("displayData")),
                        tabPanel("Plot", plotOutput("mygraph"))
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    mylabel <- reactive({
        if(input$Area=='price_index'){
            lable <- "Plot for Global market"
        }
        if(input$Area=='price_index_US'){
            lable <- "Plot for North American Indices"
        }
        if(input$Area=='price_index_EU'){
            lable <- "Plot for European Indices"
        }
        if(input$Area=='price_index_China'){
            lable <- "Plot for Chinese Indices"
        }
        lable
    })
        
    myFinalData <- reactive({
        #------------------------------------------------------------------
        # Select data according to selection of ratdio button
        if(input$Area=='price_index'){
            mydata <- price_index
        }
        
        if(input$Area=='price_index_US'){
            mydata <- price_index_US
        }
        
        if(input$Area=='price_index_EU'){
            mydata <- price_index_EU
        }
        
        if(input$Area=='price_index_China'){
            mydata <- price_index_China
        }
        #------------------------------------------------------------------
        # Get data rows for selected year
        mydata1 <- mydata[mydata$year >= input$YearRange[1], ] # From Year
        mydata1 <- mydata1[mydata1$year <= input$YearRange[2], ] # To Year
        #------------------------------------------------------------------
        
        
        
        # Get data rows for selected year
        data.frame(mydata1)
       
        #------------------------------------------------------------------
        
    })
    # Prepare "Data tab"
    output$displayData <- renderTable({
        myFinalData()
    })
    # Prepare Structure Tab
    renderstr <- reactive({ str(myFinalData())})
    
    output$struct <- renderPrint({
        renderstr()
    })
    # Prepare Summary Tab
    rendersumry <- reactive({ summary(myFinalData())})
    
    output$sumry <- renderPrint({
        rendersumry()
    })
    # Prepare Plot Tab
    output$mygraph <- renderPlot({
        plotdata <- myFinalData()
        plot(plotdata, col=c(1,2,3,4,5,6,7,8), main=mylabel())
    
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
