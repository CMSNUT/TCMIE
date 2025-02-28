#' Retrieve active compounds from the data table
#'
#' @param pool dbPool
#' @param herb_ingredient_table herb_ingredient table name in database
#' @param ingredient_table ingredient table name in database
#' @param herbs herbs name chars
#' @param ob OB thr
#' @param dl DL thr
#' @param ro5 RO5 thr
#'
#' @return data
#'
#' @export
#'
#' @name get_active_compounds
#'
#' @examples
#' library(pool)
#' library(DBI)
#' library(RSQLite)
#'
#' disease <- "chronic heart failure"
#' dbname <- system.file("app/data/tcmie.db", package = "TCMIE")
#'
#' pool <- pool::dbPool(
#'   drv = RSQLite::SQLite(),  # SQLite 驱动
#'   dbname = db
#' )
#'
#' active_compounds <- get_active_compounds(
#'   pool,
#'   "herb_ingredient",
#'   "ingredient",
#'   herbs,
#'   ob='Y',
#'   dl = 0.18,
#'   ro5 = 2,
#' )
get_active_compounds <- function(
    pool,
    herb_ingredient_table,
    ingredient_table,
    herbs,
    ob=NULL,
    dl=NULL,
    ro5=NULL
) {
  # 使用 tryCatch 捕获错误
  tryCatch({
    # 检查参数
    if (is.null(pool)) {
      stop("数据库连接池不能为空！")
    }
    if (is.null(herb_ingredient_table) || is.null(ingredient_table)) {
      stop("草药成分表和成分表名称不能为空！")
    }
    if (is.null(herbs) || length(herbs) == 0) {
      stop("草药名称列表不能为空！")
    }

    # 构建基础 SQL 查询
    query <- sprintf(
      "SELECT hi.*, i.*
       FROM %s hi
       JOIN %s i ON hi.Ingredient_ID = i.Ingredient_ID
       WHERE hi.Chinese_Name IN ('%s')",
      herb_ingredient_table,
      ingredient_table,
      paste(herbs, collapse = "','")
    )

    # 添加可选筛选条件
    if (!is.null(ob)) {
      query <- paste0(query, " AND i.OB = '", ob, "'")
    }
    if (!is.null(dl)) {
      query <- paste0(query, " AND i.DL >= ", dl)
    }
    if (!is.null(ro5)) {
      query <- paste0(query, " AND i.ALERTS <= ", ro5)
    }

    # 执行查询
    data <- dbGetQuery(pool, query)

    # 返回结果
    return(data)
  }, error = function(e) {
    # 捕获错误并返回友好的提示信息
    message("查询失败：", e$message)
    return(NULL)  # 返回 NULL 表示查询失败
  })
}
