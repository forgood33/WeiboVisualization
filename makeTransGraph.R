library(igraph)

makeTransGraph <- function(table) {
  
  #取出邻接表
  adjList <- subset(table, select = c(origin_un, forward_un, sentiment))
  
  #在数据表中添加边颜色数据
  adjList[, "edgeColor"] <- NA
  adjList$sentiment <- as.numeric(adjList$sentiment)
  adjList$edgeColor[adjList$sentiment > 0] <- "red"
  adjList$edgeColor[adjList$sentiment < 0] <- "green"
  adjList$edgeColor[adjList$sentiment == 0.0] <- "yellow"
  
  #生成图对象
  adjNet <- graph.data.frame(adjList)
  
  outDegee <- degree(adjNet, mode = "out")
  
  #为每条边加上相应颜色
  E(adjNet)$color <- E(adjNet)$edgeColor
  
  set.seed(1234)
  glay <- layout.fruchterman.reingold(adjNet)
  
  # plot
  par(bg = "darkgrey", mar = c(1,1,1,1), family = "STKaiti")
  plot(adjNet, layout = glay,
       vertex.color = "gray25",
       vertex.size = 10,
       #vertex.label=ver_labs,
       vertex.label.family = "STKaiti",
       vertex.shape = "none",
       vertex.label.color = "darkblue", #顶点文字颜色
       vertex.label.cex = ifelse(((log(outDegee + 2)) > 5), 5, log(outDegee + 2)), #顶点文字字体大小
       edge.arrow.size = 0.8,
       edge.arrow.width = 0.8,
       edge.width = 3 #edge.color = hsv(h = .95, s = 1, v = .7, alpha = 0.5
       )
  # add title
  title("微博转发图",
        col.main = "gray95", family = "STSong")
  legend("topright",
         legend = c("积极", "消极", "中立"),
         lty = 1,
         col = c("red", "green","yellow"),
         cex = 1.3)
}