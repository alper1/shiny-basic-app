library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(maptools)
library(magrittr)
library(dplyr)
library(ggmap)
library(RColorBrewer)
library(rgdal)
library(leaflet)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #accident data
  data_acc_09<-read.csv("2009.csv",sep=",")
  data_acc_10<-read.csv("2010.csv",sep=",")
  data_acc_11<-read.csv("2011.csv",sep=",")
  data_acc_12<-read.csv("2012.csv",sep=",")
  data_acc_13<-read.csv("2013.csv",sep=",")
  data_acc_14<-read.csv("2014.csv",sep=",")
  data_acc_15<-read.csv("2015.csv",sep=",")
  data_acc_16<-read.csv("2016.csv",sep=",")
  sum<-read.csv("SUM.csv",sep=",")
  

  #map data
  mapp<-readOGR("DISTRITOS_20151002.shp", layer="DISTRITOS_20151002",stringsAsFactors = F, use_iconv = TRUE, encoding = "UTF-8")
  mapp@data<-mapp@data[order(mapp@data$NOMDIS),]
  mapp@data$NOMDIS <- toupper(mapp@data$NOMDIS)
  mapp@data$NOMBRE <- toupper(mapp@data$NOMBRE)
  
  mapp@data<-cbind(mapp@data, data_acc_09$TOTAL[1:21])
  colnames(mapp@data)[5] <- "total_accidents_09"
  mapp@data<-cbind(mapp@data, data_acc_10$TOTAL[1:21])
  colnames(mapp@data)[6] <- "total_accidents_10"
  mapp@data<-cbind(mapp@data, data_acc_11$TOTAL[1:21])
  colnames(mapp@data)[7] <- "total_accidents_11"
  mapp@data<-cbind(mapp@data, data_acc_12$TOTAL[1:21])
  colnames(mapp@data)[8] <- "total_accidents_12"
  mapp@data<-cbind(mapp@data, data_acc_13$TOTAL[1:21])
  colnames(mapp@data)[9] <- "total_accidents_13"
  mapp@data<-cbind(mapp@data, data_acc_14$TOTAL[1:21])
  colnames(mapp@data)[10] <- "total_accidents_14"
  mapp@data<-cbind(mapp@data, data_acc_15$TOTAL[1:21])
  colnames(mapp@data)[11] <- "total_accidents_15"
  mapp@data<-cbind(mapp@data, data_acc_16$TOTAL[1:21])
  colnames(mapp@data)[12] <- "total_accidents_16"
  
  output$Selector <- renderUI({
    radioButtons(inputId = "year_id", label="Years",
                       choices=unique(sum$YEAR))
  })
  
  output$Selector2 <- renderUI({
    checkboxGroupInput(inputId = "dist_id", label="Districts",
                       choices=unique(sum$DISTRITO_ACCIDENTE),selected=unique(sum$DISTRITO_ACCIDENTE[1]))
  })
  
  output$maptext <- renderText({
    toString(paste("Madrid Map: Red to black according to the #accident"))
  })
  
  output$plotmap <- renderPlot({
    
    #map with accidents
    if (input$year_id==2009){
      x <- as.numeric(mapp@data$total_accidents_09)
    }
    if (input$year_id==2010){
      x <- as.numeric(mapp@data$total_accidents_10)
    }
    if (input$year_id==2011){
      x <- as.numeric(mapp@data$total_accidents_11)
    }
    if (input$year_id==2012){
      x <- as.numeric(mapp@data$total_accidents_12)
    }
    if (input$year_id==2013){
      x <- as.numeric(mapp@data$total_accidents_13)
    }
    if (input$year_id==2014){
      x <- as.numeric(mapp@data$total_accidents_14)
    }
    if (input$year_id==2015){
      x <- as.numeric(mapp@data$total_accidents_15)
    }
    if (input$year_id==2016){
      x <- as.numeric(mapp@data$total_accidents_16)
    }
    #map plot
    x <- (x - min(x))/(max(x)-min(x))
    color_county <- rgb(x,0,0) #create a scale from black to red
    plot(mapp,col=color_county,border=color_county)
   })
  
  
  output$plotline <- renderPlot({
   
      selected_data <- sum[(sum$DISTRITO_ACCIDENTE%in%input$dist_id),]
      gg <- ggplot(selected_data, aes(x = YEAR,y=TOTAL,col=DISTRITO_ACCIDENTE)) + labs(col="DISTRITO_ACCIDENTE")+ylab("Number of Accidents")
      gg +  geom_line() + ggtitle("Number of Accidents & Years for Districts")
  })
  
})
