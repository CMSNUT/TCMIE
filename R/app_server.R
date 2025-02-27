#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyBS
#' @import shinyjs
#' @import DBI
#' @import tidyverse
#' @import pool
#' @import RSQLite
#' @noRd
app_server <- function(input, output, session, pool) {
  observeEvent(input$backToTop, {
    shinyjs::runjs("$('.tab-content').animate({ scrollTop: 0 }, 'slow');") # 使用 shinyjs 执行 JavaScript
  })

  # 网络药理
  mod_gui_np_server("np",pool)


}
