library(RMySQL)

initialConnection <- function() {
  con <- dbConnect(MySQL(), user = "root", password = "root", 
                   db = "weibo", host = "127.0.0.1", port = 3306)
  dbSendQuery(con, 'SET NAMES utf8')
  
  con
}