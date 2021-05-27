#load packages

library(shiny)
library(ggmap)
library(data.table)
library(tidyverse)

#load file

load('data/station_latlon.RData')



# User interface

ui = fluidPage(
  
  
  sidebarPanel(
    
    titlePanel('서울시 지하철 정보'),
    helpText('서울시 지하철 노선도'),
    selectInput('station', 
                label='지하철 호선 선택', 
                choices = c('01호선', '02호선',
                            '03호선', '04호선',
                            '05호선', '06호선',
                            '07호선', '08호선',
                            '09호선'), 
                selected='02호선'),
    
    checkboxInput('district', 
                  label='행정구역 표시', value=FALSE),
    
    img(src='p06020100_03.gif', height=200, width=200)
    
  ),
  
  mainPanel(plotOutput('map')),
  
  hr(),
  
  fluidRow(
    
    column(3),
    column(4),
    column(4)
    
  )
  
  
  
)


# Server logic

server = function(input, output){
  
  stationInput = reactive({
    station_location[호선==input$station]
  })
  
  
  colorInput = reactive({
    
    color_list[parse_number(input$station)]
    
  })
  
  distInput = reactive({
    
    if(input$district){
      
      return(p + geom_polygon(data = seoul_map, aes(x=long, y=lat, group=group),
                              fill='black', alpha=0.2, color='white'))
      
    } else{
      
      return(p)
    }
    
  })
  
  
  output$map = renderPlot({
    
    
     distInput() + geom_point(data = stationInput(), aes(lon, lat), size = 3, colour=colorInput())
    
    
  })
  
}


# runapp

shinyApp(ui, server)