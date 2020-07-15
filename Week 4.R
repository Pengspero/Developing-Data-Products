library(readxl)
library(dplyr)
library(plotly)


# American stock
DJI <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))
NAS <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Price History_20200713_1152.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric"))

price_index_US<- merge(DJI%>%select(`Exchange Date`,Close),
                      NAS%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_US<- price_index_US%>%rename(Nasdaq=Close.x ,DJI=Close.y)
head(price_index_US)
change_index_US <- merge(DJI%>%select(`Exchange Date`,`%Chg`),
                      NAS%>%select(`Exchange Date`,`%Chg`),by="Exchange Date")
change_index_US <- change_index_US%>%rename(Nasdaq=`%Chg.x`,DJI=`%Chg.y`)
head(change_index_US)

# China 
CSI300 <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Shanghai Shenzhen CSI 300 Index.xlsx",
                  col_types = c("date","numeric","numeric","numeric"
                                ,"numeric","numeric","numeric","numeric","numeric"))
SSEC <- read_excel("/Users/Lionpf/Dropbox/Developing-Data-Products/Shanghai SE Composite Index .xlsx",
                     col_types = c("date","numeric","numeric","numeric"
                                   ,"numeric","numeric","numeric","numeric","numeric"))
price_index_China<- merge(CSI300%>%select(`Exchange Date`,Close),
                          SSEC%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_China<- price_index_China%>%rename(CSI300=Close.x ,SSEC=Close.y)
head(price_index_China)
change_index_China <- merge(CSI300%>%select(`Exchange Date`,`%Chg`),
                            SSEC%>%select(`Exchange Date`,`%Chg`),by="Exchange Date")
change_index_China <- change_index_China%>%rename(CSI300=`%Chg.x`,SSEC=`%Chg.y`)
head(change_index_China)

# Europe
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
price_index_Eng<- merge(FTSE100%>%select(`Exchange Date`,Close),
                        FTSE250%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_Eng<- price_index_Eng%>%rename(FTSE100=Close.x ,FTSE250=Close.y)
price_index_FG<- merge(CAC40%>%select(`Exchange Date`,Close),
                       DAX%>%select(`Exchange Date`,Close),by="Exchange Date")
price_index_FG <- price_index_FG%>%rename(CAC40=Close.x ,DAX=Close.y)
price_index_EU <-  merge(price_index_Eng,price_index_FG,by="Exchange Date")
head(price_index_EU)
change_index_Eng <- merge(FTSE100%>%select(`Exchange Date`,`%Chg`),
                          FTSE250%>%select(`Exchange Date`,`%Chg`),by="Exchange Date")
change_index_Eng <- change_index_Eng%>%rename(FTSE100=`%Chg.x`,FTSE250=`%Chg.y`)
change_index_FG <- merge(CAC40%>%select(`Exchange Date`,`%Chg`),
                         DAX%>%select(`Exchange Date`,`%Chg`),by="Exchange Date")
change_index_FG <- change_index_FG%>%rename(CAC40=`%Chg.x`,DAX=`%Chg.y`)
change_index_EU <- merge(change_index_Eng,change_index_FG,by="Exchange Date")
head(change_index_EU)

#Merge all
price_index1<- merge(price_index_US,price_index_China,by="Exchange Date")
price_index <- merge(price_index1,price_index_EU,by="Exchange Date")
head(price_index)

change_index1 <- merge(change_index_US,change_index_China,by="Exchange Date")
change_index <- merge(change_index1,change_index_EU,by="Exchange Date")
head(change_index)

# cleanse

library(tidyverse)
library(lubridate)


price_index <- price_index %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
        mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_US <- price_index_US %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
        mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_EU <- price_index_EU %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
        mutate_at(vars(`Exchange Date`), funs(year, month))

price_index_China <- price_index_China %>%mutate(`Exchange Date` = ymd(`Exchange Date`)) %>% 
        mutate_at(vars(`Exchange Date`), funs(year, month))
# Plot

price_plot <- plot_ly(price_index,x=~price_index$`Exchange Date`,y=~price_index$Nasdaq,
                  type = 'scatter',mode='lines',name = 'Nasdaq Index')
price_plot <- price_plot%>%add_trace(y=~price_index$DJI,name='Dow Jones Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$CSI300,name='CSI 300 Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$SSEC,name='SSEC Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$FTSE100,name='FTSE100 Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$FTSE250,name='FTSE250 Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$CAC40,name='CAC400 Index',mode='lines+markers')
price_plot <- price_plot%>%add_trace(y=~price_index$DAX,name='DAX Index',mode='lines+markers')
price_plot <- price_plot%>%layout(title="The trends of stock indices", 
                          yaxis=list(title="Index Price"),
                          xaxis=list(title="Date"))
price_plot

change_plot <- plot_ly(change_index,x=~change_index$`Exchange Date`,y=~change_index$Nasdaq,type = 'scatter',mode='lines+markers',
                  name = 'Nasdaq volatility')
change_plot <- change_plot%>%add_trace(y=~change_index$DJI,name='Dow Jones volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$CSI300,name='CSI300 volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$SSEC,name='SSEC volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$FTSE100,name='FTSE100 volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$FTSE250,name='FTSE250 volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$CAC40,name='CAC40 volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%add_trace(y=~change_index$DAX,name='DAX volatility',
                                       mode='lines+markers')
change_plot <- change_plot%>%layout(title="The volatility of stock indices", 
                                  yaxis=list(title="Volatility rate"),
                                  xaxis=list(title="Date"))
change_plot

