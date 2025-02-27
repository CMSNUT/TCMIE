#' getActiveCompounds
#'
#' @description A fct function
#'
#' @param db database
#' @param table table in database
#' @param herbs herbs name chars
#' @param ob OB thr
#' @param dl DL thr
#' @param ro5 RO5 thr
#'
#' @return res
#'
#' @export
#'
#' @noRd
library(dplyr)
library(dplyr)
getActiveCompounds <- function(db,table,herbs,ob=NULL,dl=NULL,ro5=NULL) {
  sql <- paste0("SELECT * FROM ",table," WHERE")
}
