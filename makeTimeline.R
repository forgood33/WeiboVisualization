library(ggplot2)
library(plotly)

makeTimeline <- function(table) {
  #把转发时间转换成时间对象
  table$forward_time <- as.POSIXlt(table$forward_time)
  
  #添加转发时间按小时分段
  table$hour <- cut(as.POSIXlt(table$forward_time), breaks = "hour")
  table$hour <- as.POSIXlt(table$hour)
  RTlist <- cbind.data.frame(seq.POSIXt(min(table$hour), max(table$hour), "hours"), 0)
  colnames(RTlist) <- c("forward_time", "times")
  RTlist$hour <- cut(RTlist$forward_time, breaks = "hour")
  table$hour <- as.character(table$hour)
  aggByHour <- aggregate(origin_un ~ hour, data = table, length)
  aggByHour$hour <- as.character(aggByHour$hour)
  RTlist$hour <- as.character(RTlist$hour)
  k <- merge(RTlist, aggByHour, by = "hour", all = TRUE)
  k[is.na(k)] <- 0
  
  
  #plot
  ggiris <- ggplot(k, aes(x = forward_time, y = origin_un))
  ggiris <- (ggiris #+ geom_point(color = "steelblue", size = 2, alpha = 0.9)
         + geom_line(color = "red", alpha = 0.2)
         #+ ylim(c(0, max(aggByHour$ID))) #scale_y_discrete(breaks = seq(0, max(aggByHour$ID), 1))
         + labs(title = "整点时刻之后一小时内的转发量")
         + labs(x = "", y = "转发次数"))
  
  py <- plotly("forgood33", "wypwqhoj97", "https://plot.ly")  # Open Plotly connection
  
  res <- py$ggplotly(ggiris, kwargs=list(filename="微博转发曲线", 
                                         fileopt="overwrite", # Overwrite plot in Plotly's website
                                         auto_open=FALSE))
  
  tags$iframe(src=res$response$url,
              frameBorder="1",  # Some aesthetics
              height=400,
              width=650)
}