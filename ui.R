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

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  titlePanel("Alper Kocabiyik - Traffic Accidents in Districts of Madrid"),
  tabsetPanel(
    tabPanel("Madrid Accidents Map",
             sidebarLayout(
               sidebarPanel(
                 uiOutput("Selector"),
                 width = 2
               ),
               mainPanel(h3(textOutput("maptext")),
                         plotOutput("plotmap"),width = 5)
               , fluid = T
             )
    ),
    tabPanel("Districts in Years",
             sidebarLayout(
               sidebarPanel(
                 uiOutput("Selector2"),
                 width = 2
               ),
               mainPanel(plotOutput("plotline"))
               , fluid = T
             )
    )
  
)))
