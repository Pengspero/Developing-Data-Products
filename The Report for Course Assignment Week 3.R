library(readxl)
library(dplyr)
library(plotly)

DJI <- read_excel("Price History.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))
NAS <- read_excel("Price History_20200713_1152.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))

price_index_DJI <- DJI%>%select(`Exchange Date`,Close)
price_index_NAS <- NAS%>%select(`Exchange Date`,Close)
price_index <- merge(price_index_DJI,price_index_NAS,by="Exchange Date")
price_index <- price_index%>%rename(Nasdaq=Close.x,DJI=Close.y)
head(price_index)
change_index <- merge(DJI%>%select(`Exchange Date`,`%Chg`),
                      NAS%>%select(`Exchange Date`,`%Chg`),by="Exchange Date")
change_index <- change_index%>%rename(Nasdaq=`%Chg.x`,DJI=`%Chg.y`)
head(change_index)

plot_1 <- plot_ly(price_index,x=~price_index$`Exchange Date`,y=~price_index$Nasdaq,
                  type = 'scatter',mode='lines',name = 'Nasdaq Index')
plot_1 <- plot_1%>%add_trace(y=~price_index$DJI,name='Dow Jones Index',mode='lines+markers')
plot_1
plot_2 <- plot_ly(change_index,x=~change_index$`Exchange Date`,y=~change_index$Nasdaq,type = 'scatter',mode='lines',
                  name = 'Nasdaq volatility')
plot_2 <- plot_2%>%add_trace(y=~change_index$DJI,name='Dow Jones volatility',mode='lines+markers')
plot_2