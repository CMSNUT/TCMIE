#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @import shinydashboardPlus
#' @import shinyBS
#' @import DBI
#' @import tidyverse
#' @import pool
#' @import RSQLite
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(), # 加载 shinyjs
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css"),
      tags$script(src = "www/scripts.js") # 确保路径正确
    ),
    div(
      id = "header",
      style = "display: center;font-family: Microsoft YaHei; font-size: 30px; font-style: blod;color:white;",
      "中药智鉴"
    ),
    shinydashboardPlus::dashboardPage(
      header=shinydashboardPlus::dashboardHeader(
        # fixed = TRUE,
        titleWidth = 150,
        disable = T
      ),
      sidebar=shinydashboardPlus::dashboardSidebar(
          width = 150,
          disable = TRUE,
          sidebarMenu(
            menuItem("中药智鉴", tabName = "home", icon = icon("home")),
            menuItem("网络药理", tabName = "netpharm", icon = icon("yin-yang")),
            menuItem("分子对接", tabName = "docking", icon = icon("magnet")),
            menuItem("药物性质", tabName = "property", icon = icon("newspaper")),
            menuItem("药材质控", tabName = "quality", icon = icon("water")),
            menuItem("生信分析", tabName = "bioinfo", icon = icon("dna")),
            menuItem("数据管理", tabName = "data", icon = icon("database")),
            menuItem("实用工具", tabName = "tools", icon = icon("wrench")),
            menuItem("研究案例", tabName = "cases", icon = icon("file-powerpoint"))
          )
      ),
      body=shinydashboard::dashboardBody(

        tabItems(
          # 主页 ----
          tabItem(
            tabName = "home",
            div(
              class = "tab-content",
              # includeMarkdown("./R/home.md")
            )
          ),

          # 网药分析 ----
          tabItem(
            tabName = "netpharm",
            div(
              class = "tab-content",
              mod_gui_np_ui("np")
            )
          ),


          # 分子对接 ----
          tabItem(
            tabName = "docking",
            div(
              class = "tab-content",
            )
          ),


          # 物性预测 ----
          tabItem(
            tabName = "property",
            div(
              class = "tab-content",
            )
          ),

          # 药材质控 ----
          tabItem(
            tabName = "quality",
            div(
              class = "tab-content",
            )
          ),

          # 生信分析 ----
          tabItem(
            tabName = "bioinfo",
            div(
              class = "tab-content",
            )
          ),

          # 数据管理
          tabItem(
            tabName = "data",
            div(
              class = "tab-content",
              p("数据管理内容")
            )
          ),

          tabItem(
            tabName = "tools",
            div(
              class = "tab-content",
              p("工具内容")
            )
          ),

          tabItem(
            tabName = "cases",
            div(
              class = "tab-content",
              p("研究案例")
            )
          )

      ),

      div(
        id = "back-to-top",
        style = "display: none;", # 初始隐藏
        actionButton("backToTop", "TOP",class="btn-primary") # 按钮内容为向上的箭头
      ),
      controlbar=shinydashboardPlus::dashboardControlbar(),
      skin="blue"
    )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "中药智鉴 | TCMIE"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
