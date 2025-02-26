#' gui_np UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_gui_np_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidPage(

    sidebarLayout(
      # 左侧输入面板 ----
      sidebarPanel(
        width = 3,

        ## 中药材名称输入选择框 ----
        div(class = "input-container",strong("输入中药材中文名称:"),icon("question-circle", class = "help-icon", id = ns("help_icon"))),
        selectizeInput(ns("choose_herbs"),label = NULL,multiple = T,choices = NULL)
      ),

      # 右侧显示面板 ----
      mainPanel(
        width = 9,
      )

    ),

    # 弹出窗口（模态框）
    bsModal(
      id = ns("help_modal"),  # 模态框 ID
      title = "方剂中药材",  # 模态框标题
      trigger = ns("help_icon"),  # 触发按钮 ID
      size = "medium",  # 模态框大小
      tags$p("This is a help message for the selectizeInput.")  # 模态框内容
    )
  ))
}

#' gui_np Server Functions
#'
#' @noRd
mod_gui_np_server <- function(id,pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    # observe({
    #   print(dbListTables(pool))
    # })

    updateSelectInput(
      session = getDefaultReactiveDomain(),
      "choose_herbs",
      label = NULL,
      choices =dbGetQuery(pool,"SELECT Chinese_Name FROM herb" )[,1]
    )


  })
}

## To be copied in the UI
# mod_gui_np_ui("gui_np_1")

## To be copied in the server
# mod_gui_np_server("gui_np_1")
