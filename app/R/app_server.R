#' @import shiny
app_server <- function(input, output, session) {

  echarts4r::e_common(
    font_family = "Playfair Display",
    theme = "vintage"
  )

  output$title <- typedjs::renderTyped({
    typedjs::typed(c("What Happened to Criminals during Pandemic?^1000", "New York Criminal Analysis^500<br>A Visualisation"), typeSpeed = 25, smartBackspace = TRUE)
  })
  
  callModule(mod_ts_server, "ts")
  callModule(mod_map_server, "map")
  callModule(mod_bar_server, "bar")

}
