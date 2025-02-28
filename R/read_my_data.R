#' Retrieve the targets of disease from the data table
#'
#' @param file file path
#'
#' @return data
#'
#' @export
#'
#' @name read_my_data
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
read_my_data <- function(
    file
) {
  # 使用 tryCatch 捕获错误
  tryCatch({
    # 检查参数
    if (is.null(file)) {
      stop("文件路径不能为空！")
    }



    # 返回结果
    return(data)
  }, error = function(e) {
    # 捕获错误并返回友好的提示信息
    message("查询失败：", e$message)
    return(NULL)  # 返回 NULL 表示查询失败
  })
}
