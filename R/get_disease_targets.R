#' Retrieve the targets of disease from the data table
#'
#' @param pool dbPool
#' @param disease_target_table disease_target table name in database
#' @param disease disease name
#'
#' @return data
#'
#' @export
#'
#' @name get_disease_targets
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
#' targets <- get_disease_targets(pool,"disease_target",disease)
get_disease_targets <- function(
    pool,
    disease_target_table,
    disease
) {
  # 使用 tryCatch 捕获错误
  tryCatch({
    # 检查参数
    if (is.null(pool)) {
      stop("数据库连接池不能为空！")
    }
    if (is.null(disease_target_table)) {
      stop("疾病-靶点表名称不能为空！")
    }
    if (is.null(disease) || length(disease) == 0) {
      stop("疾病名称不能为空！")
    }

    # 构建基础 SQL 查询
    query <- sprintf(
      "SELECT *
       FROM %s
       WHERE Disease_Name = '%s'",
      disease_target_table,
      disease
    )

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
