library(ggplot2)
library(plotly)

makeEmotionChart <- function(table) {
  
  #取出邻接表
  table$comment_Sentiment <- as.numeric(table$comment_Sentiment)
  #添加情感判断项
  table[, "attitude"] <- NA
  table$attitude[table$comment_Sentiment > 0] <- "积极"
  table$attitude[table$comment_Sentiment < 0] <- "消极"
  table$attitude[table$comment_Sentiment == 0.0] <- "中立"
  table[is.na(table)] <- 0
  table$attitude <- factor(table$attitude)
  
  ggiris <- ggplot(table, aes(attitude))
  ggiris <- (ggiris
             + geom_histogram(color = "red", alpha = 0.2)
             + labs(title = "")
             + labs(x = "情感倾向", y = "评论情感计数"))
  
  py <- plotly("forgood33", "wypwqhoj97", "https://plot.ly")  # Open Plotly connection
  
  res <- py$ggplotly(ggiris, kwargs=list(filename="", 
                                          fileopt="overwrite", # Overwrite plot in Plotly's website
                                          auto_open=FALSE))
  
  tags$iframe(src=res$response$url,
              frameBorder="0",  # Some aesthetics
              height=400,
              width=650)
}