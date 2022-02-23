# Module UI
  
#' @title   mod_bar_ui and mod_bar_server
#' @description  A shiny Module.
#'
#' @param id shiny id
#' @param input internal
#' @param output internal
#' @param session internal
#'
#' @rdname mod_bar
#'
#' @keywords internal
#' @export 
#' @importFrom shiny NS tagList 

mod_bar_ui <- function(id){
  ns <- NS(id)
  pageContainer(
    h2("Criminal Counts by Race and Sex"),
    br(), 
    fluidRow(
      column(
        6,
        uiOutput(ns("race_selected"))
      ),
      column(
        6,
        uiOutput(ns("sex_selected"))
      ),
    ),
    echarts4r::echarts4rOutput(ns("trend"), height="50vh")
  )
}
    
# Module Server
    
#' @rdname mod_bar
#' @export
#' @keywords internal

mod_bar_server <- function(input, output, session){
  ns <- session$ns
  
  arrest <- arrest %>% tidyr::separate(Race_Sex, c("Race", "Sex"), "_", remove = FALSE)
  arrest$Sex <- dplyr::recode(arrest$Sex, 'F' = 'Female', 'M' = 'Male')
  
  output$race_selected <- renderUI({
    rs <-arrest %>% 
      dplyr::arrange(Race) %>% 
      dplyr::distinct(Race) %>% 
      dplyr::pull(Race)

    selectizeInput(
      ns("race_selected"),
      "Select a race",
      choices = rs,
      selected = sample(rs, 2),
      multiple = TRUE
    )
  })

  output$sex_selected <- renderUI({
    ss <-arrest %>% 
      dplyr::arrange(Sex) %>% 
      dplyr::distinct(Sex) %>% 
      dplyr::pull(Sex)
    
    selectizeInput(
      ns("sex_selected"),
      "Select a sex",
      choices = ss,
      selected = sample(ss, 1),
      multiple = TRUE
    )
  })
  
  output$trend <- echarts4r::renderEcharts4r({
    req(input$race_selected)
    req(input$sex_selected)
    
    arrest %>% 
      dplyr::filter(Race %in% input$race_selected & Sex %in% input$sex_selected) %>% 
      dplyr::group_by(Race, Sex)%>%
      dplyr::summarise(count = n())%>%
      echarts4r::e_charts(Sex) %>% 
      echarts4r::e_bar(count) %>% 
      echarts4r::e_tooltip(trigger = "axis") %>% 
      echarts4r::e_axis_labels("Sex") %>% 
      echarts4r::e_color(
        c("#247BA0", "#FF1654", "#70C1B3", "#2f2f2f", "#F3FFBD", "#B2DBBF")
      )
  })
}
