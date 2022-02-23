# Module UI
  
#' @title   mod_ts_ui and mod_ts_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_ts
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 
mod_ts_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    h2("Race & Gender vs. Number of Crimes"),
    br(),
    fluidRow(
      column(
        6,
        shinyWidgets::awesomeCheckboxGroup(
          inputId = "SexFinderr",
          label = "Gender:", 
          choices = c("Male" = "M", "Female" = "F"),
          multiple = TRUE,
          selected = c("Male" = "M", "Female" = "F"),
        )
      ),
      column(
        6,
        shinyWidgets::awesomeCheckboxGroup(
          inputId = "RaceFinder",
          label = "Race:", 
          choices = c(
            "Black" = "BLACK",
            "White" = "WHITE",
            "Black Hispanic" = "BLACK HISPANIC",
            "White Hispanic" = "WHITE HISPANIC",
            "Asian/Pacific Islander" = "ASIAN / PACIFIC ISLANDER",
            "American Indian/Alaskan Native" = "AMERICAN INDIAN/ALASKAN NATIVE"),
          multiple = TRUE,
          selected = selected = c(
            "Black" = "BLACK",
            "White" = "WHITE",
            "Black Hispanic" = "BLACK HISPANIC",
            "White Hispanic" = "WHITE HISPANIC",
            "Asian/Pacific Islander" = "ASIAN / PACIFIC ISLANDER",
            "American Indian/Alaskan Native" = "AMERICAN INDIAN/ALASKAN NATIVE")
              ),
        )
      )
    ),
    echarts4r::echarts4rOutput(ns("trend"), height="50vh")
  )
}
    
library(shiny)
library(ggplot2)
library(dplyr)
library(tidyr)
library(stringr)  

arrest <- read.csv('../data/arrest.csv') %>%
  separate(Race_Sex, c("Race", "Sex"), "_", remove = FALSE)

arrest$Race_Sex[arrest$Race_Sex == "BLACK_M"] <- "B_M"
arrest$Race_Sex[arrest$Race_Sex == "BLACK_F"] <- "B_F"
arrest$Race_Sex[arrest$Race_Sex == "WHITE_M"] <- "W_M"
arrest$Race_Sex[arrest$Race_Sex == "WHITE_F"] <- "W_F"
arrest$Race_Sex[arrest$Race_Sex == "BLACK HISPANIC_M"] <- "B&H_M"
arrest$Race_Sex[arrest$Race_Sex == "BLACK HISPANIC_F"] <- "B&H_F"
arrest$Race_Sex[arrest$Race_Sex == "WHITE HISPANIC_M"] <- "W&H_M"
arrest$Race_Sex[arrest$Race_Sex == "WHITE HISPANIC_F"] <- "W&H_F"
arrest$Race_Sex[arrest$Race_Sex == "ASIAN / PACIFIC ISLANDER_M"] <- "A|P_M"
arrest$Race_Sex[arrest$Race_Sex == "ASIAN / PACIFIC ISLANDER_F"] <- "A|P_F"
arrest$Race_Sex[arrest$Race_Sex == "AMERICAN INDIAN/ALASKAN NATIVE_M"] <- "A|A_M"
arrest$Race_Sex[arrest$Race_Sex == "AMERICAN INDIAN/ALASKAN NATIVE_F"] <- "A|A_F"




# Module Server
    
#' @rdname mod_ts
#' @export
#' @keywords internal
    
mod_ts_server <- function(input, output, session){
  ns <- session$ns

  racesexfinder <- reactive({
    req(input$RaceFinder)
    req(input$SexFinder)
    filter(arrest, Race == input$RaceFinder) %>%
      filter(Sex == input$SexFinder)
  })
  
  race_sex_finder <- reactive({
    counts <- as.data.frame(table(racesexfinder()$Race_Sex))
    colnames(counts) <- c("Race_Sex", "Counts")
    return(counts)
  })
  
  output$racesexplot <- renderPlot({
    barplot(t(race_sex_finder()$Counts),
            beside=TRUE,
            col="#69b3a2",
            # horiz=TRUE,
            # las=2,
            cex.names=.7,
            names.arg = race_sex_finder()$Race_Sex
    )
    
  })
}
