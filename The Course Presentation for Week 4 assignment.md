The Course Presentation for Week 4 assignment
========================================================
author: Pengfei LI
date: Wednesday, 15 July, 2020
autosize: true

Assignment Introduction
========================================================

### **The Shiny Application**
* Write a shiny application with associated supporting documentation;
* Deploy the application on Rstudio's shiny server;
* Share the application link by pasting it into the provided text box;
* Share your server.R and ui.R code on github;

### **Your Reproducible Pitch Presentation**
* 5 slides to pitch our idea done in Slidify or Rstudio Presenter;
* Your presentation pushed to github or Rpubs;
* A link to your github or Rpubs presentation pasted into the provided text box;


Data Pre-processing Procedure
========================================================
In this section, only the short data summary will be presented due to the complicated.

```r
price_index <- read.csv("price_index.csv")
str(price_index)
```

```
'data.frame':	3310 obs. of  11 variables:
 $ Exchange.Date: chr  "2006-02-06" "2006-02-07" "2006-02-08" "2006-02-09" ...
 $ Nasdaq       : num  10798 10750 10859 10883 10919 ...
 $ DJI          : num  2259 2245 2267 2256 2262 ...
 $ CSI300       : num  128 128 128 127 128 ...
 $ SSEC         : num  160 159 160 158 159 ...
 $ FTSE100      : num  10086 10018 9968 10112 10053 ...
 $ FTSE250      : num  16228 16113 16090 16310 16262 ...
 $ CAC40        : num  5903 5909 5851 5937 5843 ...
 $ DAX          : num  6779 6792 6772 6880 6784 ...
 $ year         : int  2006 2006 2006 2006 2006 2006 2006 2006 2006 2006 ...
 $ month        : int  2 2 2 2 2 2 2 2 2 2 ...
```

Application
========================================================
The application in this project is also on the shiyapps website. The URL is as follows.

The application UI separate into two sections.

Left pane:

1. Select the area for the stock indices from North America, Europe and China;
2. Selcet the time horizon for data output in the right pane

Right pane:

1. Summary: This area presents the summary statistics for the select stock indices.
2. Structure: Here shows the data structure of the whole dataframe.
3. Data: The display for the data frame
4. Plot: the plot for dataframe


Application
========================================================
