#' @import shiny
app_ui <- function() {

  options <- list()

  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    pagePiling(
      sections.color = c('#2f2f2f', '#2f2f2f', '#f9f7f1', '#f9f7f1','#2f2f2f'),
      opts = options,
      menu = c(
        "Home" = "home",
        "Map" = "map",
        "Bar" = "bar",
        "Series" = "ts",
        "About" = "about"
      ),
      pageSectionImage(
        center = TRUE,
        img = "www/img/nyc.jpg",
        menu = "home",
        h1(typedjs::typed(c("What Happened to Criminals during Pandemic?^1000", "New York Criminal Analysis^500<br>A Visualisation"), typeSpeed = 25, smartBackspace = TRUE), class = "header shadow-dark"),
        h3(
          class = "light footer",
          tags$a("Applied Data Science", href = "http://tzstatsads.github.io", class = "link") ,"in Columbia"
        )
      ),
      pageSection(
        center = TRUE,
        menu = "map",
        mod_map_ui("map")
      ),
      pageSection(
        center = TRUE,
        menu = "bar",
        mod_bar_ui("bar")
      ),
      pageSection(
        center = TRUE,
        menu = "ts",
        mod_ts_ui("ts")
      ),
      pageSection(
        center = TRUE,
        menu = "about",
        h1("About", class = "header shadow-dark"),
        h2(
          class = "shadow-light",
          tags$a("Github", href = "https://github.com/TZstatsADS/spring-2022-project2-group-2", target = "_blank", class = "link"),
          "|",
          tags$a("Data1", href = "https://data.cityofnewyork.us/Public-Safety/NYPD-Arrests-Data-Historic-/8h9b-rp9u", target = "_blank", class = "link"),
          "|",
          tags$a("Data2", href = "https://data.cityofnewyork.us/Public-Safety/NYPD-Arrest-Data-Year-to-Date-/uip8-fykc", target = "_blank", class = "link")
        ),
        h4(
          class = "light footer",
          "Group member: Jun Ding | Daoyang E | Jingwei Liao | Xiran Lin"
        )
      )
    )
  )
}

#' @import shiny
golem_add_external_resources <- function(){
  
  addResourcePath(
    'www', system.file('www', package = 'fopi.app')
  )
 
  tags$head(
    golem::activate_js(),
    golem::favicon(),
    tags$link(
      rel = "stylesheet", href = shinythemes::shinytheme("sandstone")
    ),
    tags$link(rel = "stylesheet", type = "text/css", href = "www/css/style.css"),
    tags$script(async = NA, src = "https://www.googletagmanager.com/gtag/js?id=UA-74544116-1"),
    tags$script(
      "window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-74544116-1');"
    )
  )
}
