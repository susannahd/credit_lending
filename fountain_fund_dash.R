##################################################
## Code: fountain_fund_dash.R
## Project: Fountain Fund
## Description: Build shiny app to gather data on various states for Fountain Fund
## Date: October 13, 2021
## Last Updated: October 13, 2021
## Author: Susannah Derr
##################################################
rm(list=ls())
library(shiny)
library(shinydashboard)
library(tidyverse)
library(dplyr)
library(scales)
library(DT)
library(leaflet)
library(readr)
library(leaflet.minicharts)

data<-read.csv("/Users/susannah/Documents/projects/fountain_fund/Fountain Fund Data.csv")

states <- unique(data$State) %>%
  sort()


ui<-dashboardPage(skin = "black"
                  ,dashboardHeader(title = "Fountain Fund Geographic Data")
                  ,dashboardSidebar(
                    sidebarMenu(
                      id = "tabs"
                      ,menuItem("How To Guide", icon = icon("info"), tabName = "about")
                       ,menuItem("Map View", tabName = "map", icon = icon("map"))
                      ,menuItem("Table View",icon = icon("th"),tabName='table')
                      ,selectInput('state','Select the state for which you want data',choices=states,selected='Alabama',multiple=FALSE)
                      ,actionButton("update", "Update Dashboard")
                    )),
                  
                  dashboardBody(
                    tabItems(
                      tabItem("about" 
                              ,fluidRow(
                                column(width = 9,
                                       column(12, h1("How To Guide: Fountain Fund Dashboard"))
                                       ,column(12,h4("This is the first version of a dashboard to build data for Fountain Fund to use in needs statements. It incorporates data from the World Population Review (Prison Population Data) and Harvard's Criminal Justice Debt Reform page."))
                                       ,column(12,h4("All of the data was consolidated into a single dataset to help understand the Fountain Fund's potential for impact in a given city, based on data on criminal justice reform and prison data."))
                                       ,column(12,h4("By using the dropdown on the home page, users can select a state to pull data. Each tab will display data related to the state. You can download the information as needed."))
                                ))#End fluidRow
                      )#End tabItem about
                      ##TAB ITEM MAP                      
                      ,tabItem("map"
                               ,fluidRow(
                                 column(width = 12,
                                        box(width = NULL, solidHeader = TRUE,
                                            leafletOutput("local_map", height = 800))
                                 ))#End fluidRow
                      )#End tabItem map
                      ##TAB ITEM RANK
                      ,tabItem("table"
                               ,fluidRow()
                               ,fluidRow(column(DT::dataTableOutput("table_data"),width=12))
                               ,fluidRow(p(class = 'text-center', downloadButton('downloader', 'Download Table')))
                               #End fluidRow
                      )#End tabItem detail
                    )#End tabItems
                  )#End dashboardBody
)#End ui

##SERVER
####################################################
server <- function(input, output) {
  
  ##DATA
  ranked_data<-eventReactive(input$update, {
     ranked_data<-data %>%
       filter(State==input$state) %>%
       select(-c(latitude,longitude)) %>%
       rename(`Organization Name`=organization_name,`Service Category`=service_category)
  })
  

  ##OUTPUTS
  ############################################################  
  ##MAP VIEW
   output$local_map <- renderLeaflet({
     
    pal<-colorNumeric(
      palette="Blues",
      domain=data$prison_population)

    map <- leaflet(data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(
        ~longitude,
        ~latitude,
        color = ~pal(prison_population),
        label = ~as.character(organization_name),
        opacity = 0.8,
        radius = 8,
        popup=~State
      )
  })
  
  ##RANK VIEW
  #dataTable,top cities
  output$table_data<-DT::renderDataTable({
    datatable(ranked_data(),rownames=FALSE)
  })  
  
  # ##DOWNLOAD TABLE
  output$downloader <- downloadHandler(
    filename = function() {
      paste0('Fountain Fund Data ',input$state," ",Sys.Date(),".csv")
    },
    
    content = function(file) {
      write.csv(ranked_data(),file,row.names=FALSE)
    }
  )
  
}
shinyApp(ui, server)