#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  # 初始化 SQLite 连接池
  pool <- init_db_pool()

  # 应用停止时关闭连接池
  onStop(function() {
    pool::poolClose(pool)
  })

  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      # server = app_server,
      server = function(input, output, session) {
        app_server(input, output, session, pool = pool)
      },
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
