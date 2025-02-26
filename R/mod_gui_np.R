#' gui_np UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @importFrom shinyBS bsModal
mod_gui_np_ui <- function(id) {
  ns <- NS(id)
  tagList(fluidPage(sidebarLayout(
    # 左侧输入面板 ----
    sidebarPanel(
      width = 3,

      ## 中药材名称输入选择框 ----
      div(
        class = "input-container",
        strong("输入中药材中文名称:"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("choose_herbs_help_icon")
        )
      ),
      selectizeInput(
        ns("choose_herbs"),
        label = NULL,
        multiple = T,
        choices = NULL
      ),

      ## 药材活性成分筛选阈值设置 ----
      strong("药材活性成分筛选阈值设置:"),

      ### 口服利用度 OB ----

      div(
        class = "input-container",
        checkboxInput(ns("ob_threshold_setting"), label = "口服利用度(OB%)"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("ob_threshold_setting_help_icon")
        )
      ),
      conditionalPanel(
        ns = ns,
        condition = "input.ob_threshold_setting",
        sliderInput(
          ns("ob_threshold"),
          label = NULL ,
          min = 0,
          max = 100,
          step = 1,
          value = 30
        )
      ),

      ### 类药性指数 DL ----
      div(
        class = "input-container",
        checkboxInput(ns("dl_threshold_setting"), label = "类药性指数(DL)"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("dl_threshold_setting_help_icon")
        )
      ),
      conditionalPanel(
        ns = ns,
        condition = "input.dl_threshold_setting",
        sliderInput(
          ns("dl_threshold"),
          label = NULL ,
          min = 0,
          max = 1,
          step = 0.01,
          value = 0.18
        )
      ),

      ### RO5规则 ----
      div(
        class = "input-container",
        checkboxInput(ns("ro5_threshold_setting"), label = "违背Lipinski规则(RO5)的数量容忍值"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("ro5_threshold_setting_help_icon")
        )
      ),
      conditionalPanel(
        ns = ns,
        condition = "input.ro5_threshold_setting",
        sliderInput(
          ns("ro5_threshold"),
          label = NULL,
          min = 0,
          max = 5,
          step = 1,
          value = 2
        )
      ),

      ## 活性成分--靶标关联性阈值 ----
      div(
        class = "input-container",
        strong("活性化合物--靶标关联性阈值:"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("compound_target_threshold_help_icon")
        )
      ),
      sliderInput(
        ns("compound_target_threshold"),
        label = NULL,
        min = 0,
        max = 1000,
        value = 400,
        step = 1
      ),

      ## 活性成分--靶标相互作用显著性阈值 ----
      div(
        class = "input-container",
        strong("活性成分--靶标相互作用显著性阈值:"),
        icon(
          "question-circle",
          class = "help-icon",
          id = ns("compound_target_pvalue_threshold_help_icon")
        )
      ),
      numericInput(
        ns("compound_target_pvalue_threshold"),
        label = NULL,
        min = 0,
        max = 1,
        value = 0.05
      ),

      ## 疾病靶点 ----
      radioButtons(
        ns("disease_target_setting"),
        "疾病靶点设置:",
        choices = c("数据库选择" = "disease_db", "自定义设置" = "disease_custom")
      ),

      conditionalPanel(
        ns = ns,
        condition = "input.disease_target_setting == 'disease_db'",
        div(
          class = "input-container",
          strong("选择疾病:"),
          icon(
            "question-circle",
            class = "help-icon",
            id = ns("disease_target_db_help_icon")
          )
        ),
        selectizeInput(
          ns("disease_target_db"),
          label = NULL,
          multiple = F,
          choices = NULL
        )
      ),
      conditionalPanel(
        ns = ns,
        condition = "input.disease_target_setting == 'disease_custom'",
        textInput(
          ns("disease_name"),
          "输入疾病名称",
          placeholder = "输入临床疾病名称",
          value = "临床疾病"
        ),
        div(
          class = "input-container",
          strong("上传疾病靶点文件:"),
          icon(
            "question-circle",
            class = "help-icon",
            id = ns("disease_target_custom_help_icon")
          )
        ),
        fileInput(
          ns("disease_target_custom"),
          label = NULL,
          accept = c(".csv", ".xlsx", ".xls", ".txt"),
          buttonLabel = "浏览...",
          placeholder = "选择疾病-靶点文件",
        )
      ),


    ),

    # 右侧显示面板 ----
    mainPanel(
      width = 9,

      ## 模态框：中药材 ----
      bsModal(
        id = ns("choose_herbs_help_modal"),
        # 模态框 ID
        title = strong("中药材", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("choose_herbs_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p(
            "TCMIE v1.0共计收录",
            strong(1630, style = "color:red;"),
            "个常用中药材及其化学成分（包括SMILES,MOL2结构、物性参数）。可同时选择多味中药材组成中药复方。"
          ),
          h5("参考文献："),
          tags$ul(tags$li("Xu et al.， 2012"))
        )
      ),

      ## 模态框：口服利用度 ----
      bsModal(
        id = ns("ob_threshold_setting_help_modal"),
        # 模态框 ID
        title = strong("口服生物利用度(Oral Bioavailability, OB)", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("ob_threshold_setting_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p(
            "OB表示口服剂量的未改变药物到达体循环的百分比，揭示了药物分子的 ADME 性能。高口服生物利用度通常是确定生物活性分子作为治疗剂的类药特性的关键指标。通常设置OB >= 30%"
          ),
          tags$hr(),
          h5("参考文献："),
          tags$ul(tags$li("Xu et al.， 2012"))
        )
      ),

      ## 模态框：类药性 ----
      bsModal(
        id = ns("dl_threshold_setting_help_modal"),
        # 模态框 ID
        title = strong("类药性(Drug-Like, DL)指数", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("dl_threshold_setting_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p(
            "DL是药物设计中使用的定性概念，用于估计潜在化合物的“药物相似性”，这有助于优化药代动力学和药物特性，例如溶解度和化学稳定性。一般设置化合物的“类药”水平大于等于 0.18，作为传统中草药中“类药”化合物的选择标准。"
          ),
          tags$hr(),
          h5("参考文献："),
          tags$ul(tags$li("Tao et al.， 2013"))
        )
      ),

      ## 模态框：Lipinski规则 ----
      bsModal(
        id = ns("ro5_threshold_setting_help_modal"),
        # 模态框 ID
        title = strong("Lipinski规则: 类药五原则（rule of five）", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("ro5_threshold_setting_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p(
            "应用Lipinski规则进行类药性筛选，数值为0~5，表示违背Lipinski规则的数目，数目越大，类药性越差。"
          ),
          p("类药五原则（rule of five）也称为Lipinski规则，其内容如下：一个小分子药物中要具备以下性质: "),
          tags$ul(
            tags$li("氢键给体(Hdon)数目不超过5个"),
            tags$li("氢键受体(Hacc)数目不超过10个"),
            tags$li("脂水分配系数(LogP)不超过5"),
            tags$li("分子量(MW)不超过500"),
            tags$li("可旋转键数(RBN)不超过10个")
          ),
          tags$hr(),
          h5("参考文献："),
          tags$ul(
            tags$li(
              "Lipinski, C.A.; Lombardo, F.; Dominy, B.W.; Feeney, P.J. Experimental and computational approaches to estimate solubility and permeability in drug discovery and development settings. Adv. Drug Delivery Rev.1997, 23, 3-25."
            )
          )
        )
      ),


      ## 模态框：化合物-靶标关联评分 ----
      bsModal(
        id = ns("compound_target_threshold_help_modal"),
        # 模态框 ID
        title = strong("化合物-靶标关联评分", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("compound_target_threshold_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p(
            "此评分主要来自于STITCH数据库的化合物-靶标关联评分，评分越大关联性越强，STITCH数据库中关联评分的中位值为400."
          ),
          strong("注意：非STITCH数据库的化合物-靶标无关联评分，统一用9999代替！"),
          tags$hr(),
          h5("参考文献："),
          tags$ul(
            tags$li(
              "Szklarczyk, D.; Santos, A.; von Mering, C.; Jensen, L. J.; Bork, P.; Kuhn, M., STITCH 5: augmenting protein-chemical interaction networks with tissue and affinity data. Nucleic acids research 2016, 44, D380-4."
            ),
            tags$li(
              "Ming Yang, Jia-Lei Chen, Li-Wen Xu, Guang Ji. Navigating Traditional Chinese Medicine Network Pharmacology and Computational Tools. Evidence-Based Complementary and Alternative Medicine, 2013,731969. DOI:",
              tags$a(href = "https://doi.org/10.1155/2013/731969", "10.1155/2013/731969")
            )
          )
        )
      ),

      ## 模态框：活性成分--靶标相互作用显著性 ----
      bsModal(
        id = ns("compound_target_pvalue_threshold_help_modal"),
        # 模态框 ID
        title = strong("活性成分--靶标相互作用显著性", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("compound_target_pvalue_threshold_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p("按照二项分布理论计算靶标与k个以上活性成分具有相互作用的概率P（X≥k）"),
          strong("p值越小筛选到的靶标越重要，默认P<0.05表示显著"),
          tags$hr(),
          h5("参考文献："),
          tags$ul(
            tags$li(
              "Ming Yang, Jialei Chen, Liwen Xu, Xiufeng Shi, Xin Zhou, Zhijun Xi, Rui An, and Xinhong Wang., A Network Pharmacology Approach to Uncover the Molecular Mechanisms of Herbal Formula Ban-Xia-Xie-Xin-Tang, Evidence-Based Complementary and Alternative Medicine, vol. 2018, Article ID 405071."
            ),
            tags$li(
              "X. J. Liang,H. Y. Li,S. Li. A novel network pharmacology approach to analyse traditional herbal formulae: the Liu-Wei-Di-Huang pill as a case study. Molecular Biosystems, 2014, 10(5): 1014-1022. DOI:",
              tags$a(href = "https://doi.org/10.1155/2013/731969", "10.1155/2013/731969")
            )
          )
        )
      ),

      # 模态框：疾病靶点选择 ----
      bsModal(
        id = ns("disease_target_db_help_modal"),
        # 模态框 ID
        title = strong("疾病-靶点数据", style = "color:#3185B0"),
        # 模态框标题
        trigger = ns("disease_target_db_help_icon"),
        # 触发按钮 ID
        size = "medium",
        # 模态框大小
        tags$div(
          style = "text-align: justify;",
          p("收集疾病XX种，靶点XX个，"),
          p("疾病-靶点数据一览表:"),
          tags$ul(tags$li(
            paste("OMIM: ", "5676" , "Updated date: 2025-02-26")
          ), tags$li(
            paste("OMIM: ", "5676" , "Updated date: 2025-02-26")
          )),

          tags$hr(),
          h5("参考文献："),
          tags$ul(
            tags$li(
              "Ming Yang, Jialei Chen, Liwen Xu, Xiufeng Shi, Xin Zhou, Zhijun Xi, Rui An, and Xinhong Wang., A Network Pharmacology Approach to Uncover the Molecular Mechanisms of Herbal Formula Ban-Xia-Xie-Xin-Tang, Evidence-Based Complementary and Alternative Medicine, vol. 2018, Article ID 405071."
            ),
            tags$li(
              "X. J. Liang,H. Y. Li,S. Li. A novel network pharmacology approach to analyse traditional herbal formulae: the Liu-Wei-Di-Huang pill as a case study. Molecular Biosystems, 2014, 10(5): 1014-1022. DOI:",
              tags$a(href = "https://doi.org/10.1155/2013/731969", "10.1155/2013/731969")
            )
          )
        )
      )

    )

  )))
}

#' gui_np Server Functions
#'
#' @noRd
mod_gui_np_server <- function(id, pool) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      # print(input$active_settings)
      # print(input$active_settings %in% 'OB')
    })

    updateSelectInput(
      session = getDefaultReactiveDomain(),
      "choose_herbs",
      label = NULL,
      choices = dbGetQuery(pool, "SELECT Chinese_Name FROM herb")[, 1]
    )


  })
}

## To be copied in the UI
# mod_gui_np_ui("gui_np_1")

## To be copied in the server
# mod_gui_np_server("gui_np_1")
