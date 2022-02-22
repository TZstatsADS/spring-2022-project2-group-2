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
mod_bar_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    h2("Criminal Type Counts Through Time"),
    br(),
    fluidRow(
      column(
        6,
        uiOutput(ns("criminal_type_selected"))
      ),
      column(
        6,
        shinyWidgets::radioGroupButtons(
          inputId = ns("value"),
          label = "Metric",
          choices = c("count", "percentage"),
          checkIcon = list(
            yes = icon("ok",
            lib = "glyphicon")
          )
        )
      )
    ),
    echarts4r::echarts4rOutput(ns("trend"), height="50vh")
  )
}
    
# Module Server
    
#' @rdname mod_ts
#' @export
#' @keywords internal
    
arrest <- read.csv('../data/arrest.csv')

mod_bar_server <- function(input, output, session){
  ns <- session$ns

  output$criminal_type_selected <- renderUI({
    cns <-arrest %>% 
      dplyr::arrange(OFNS_DESC) %>% 
      dplyr::distinct(OFNS_DESC) %>% 
      dplyr::pull(OFNS_DESC)

    selectizeInput(
      ns("criminal_type_selected"),
      "Search a criminal type",
      choices = cns,
      selected = sample(cns, 2),
      multiple = TRUE
    )
  })

  output$trend <- echarts4r::renderEcharts4r({
    req(input$criminal_type_selected)

    temp <- arrest %>% 
      dplyr::mutate(Year_Quarter = as.character(Year_Quarter)) %>% 
      dplyr::arrange(Year_Quarter) %>% 
      dplyr::filter(OFNS_DESC %in% input$criminal_type_selected) %>% 
      dplyr::group_by(Year_Quarter)%>%
      dplyr::summarise(total_count  = n())
    
    
    arrest %>% 
      dplyr::mutate(Year_Quarter = as.character(Year_Quarter)) %>% 
      dplyr::arrange(Year_Quarter) %>% 
      dplyr::filter(OFNS_DESC %in% input$criminal_type_selected) %>% 
      dplyr::group_by(OFNS_DESC,Year_Quarter)%>%
      dplyr::summarise(count = n())%>%
      left_join(temp, by = "Year_Quarter")%>%
      dplyr::mutate(percentage = round(count/total_count, 2))%>% 
      echarts4r::e_charts(Year_Quarter) %>% 
      echarts4r::e_line_(input$value) %>% 
      echarts4r::e_tooltip(trigger = "axis") %>% 
      echarts4r::e_y_axis(inverse = TRUE) %>% 
      echarts4r::e_axis_labels("Year_Quarter") %>% 
      echarts4r::e_color(
        c("#247BA0", "#FF1654", "#70C1B3", "#2f2f2f", "#F3FFBD", "#B2DBBF")
      )
  })
}
