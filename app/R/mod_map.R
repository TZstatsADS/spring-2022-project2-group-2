
#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' 

library(dplyr)

mod_map_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    class = "light",
    h2("Criminal Areas through time"),
    shinyWidgets::radioGroupButtons(
      inputId = ns("value"),
      label = "Map Division",
      choices = c("Borough", "Precinct"),
      checkIcon = list(
        yes = icon("ok",
                   lib = "glyphicon")
      )
    ),
    echarts4r::echarts4rOutput(ns("map"), height = "50vh"),
    uiOutput(ns("desc"))
  )
}

#' map Server Function
#'
#' @noRd
#' 

arrest <- read.csv('data/arrest.csv')

nyc_boro <- jsonlite::read_json('data/boroughs.geojson')
nyc_precinct <- jsonlite::read_json('data/police_precincts.geojson')

mod_map_server <- function(input, output, session){
  ns <- session$ns
  
  output$desc <- renderUI({
    msg <- paste0(tools::toTitleCase(input$value), ", the lighter the less, from 2018 to 2021")
    
    tags$i(msg)
  })
  
  output$map <- echarts4r::renderEcharts4r({
    if (input$value == "Borough") {
      arrest %>% 
        count(ARREST_BORO, Year_Quarter) %>%
        group_by(Year_Quarter) %>%
        echarts4r::e_charts(ARREST_BORO, timeline = TRUE) %>% 
        echarts4r::e_map_register("nyc_boro", nyc_boro) %>% 
        echarts4r::e_map(n, map = "nyc_boro", name = 'Borough') %>%
        afterecharts()
    } else {
      arrest %>% 
        count(ARREST_PRECINCT, Year_Quarter) %>%
        group_by(Year_Quarter) %>%
        echarts4r::e_charts(ARREST_PRECINCT, timeline = TRUE) %>% 
        echarts4r::e_map_register("nyc_precinct", nyc_precinct) %>% 
        echarts4r::e_map(n, map = "nyc_precinct", name = 'Precinct') %>%
        afterecharts()
    }
  })
}


afterecharts <- function(echart) {
  echart %>%
    echarts4r::e_visual_map(n,
                            top = 'middle',
                            textStyle = list(color = "#fff"),
                            outOfRange = list(
                              color = "#2f2f2f"
                            ),
                            inRange = list(
                              color = c("#B2DBBF", "#247BA0")
                            )
    ) %>% 
    echarts4r::e_color(background = "rgba(0,0,0,0)") %>%  
    echarts4r::e_tooltip() %>% 
    echarts4r::e_timeline_opts(
      playInterval = 600, 
      currentIndex = 1,
      symbolSize = 4, 
      label = list(
        color = "#f9f7f1"
      ),
      checkpointStyle = list(
        color = "#f9f7f1"
      ),
      lineStyle = list(
        color = "#f9f7f1"
      ),
      controlStyle = list(
        color = "#f9f7f1",
        borderColor = "#f9f7f1"
      )
    )
}

