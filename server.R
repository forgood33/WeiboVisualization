library(shiny)
source("makeTimeline.R")
source("makeTransGraph.R")
source("makeEmotionChart.R")
source("databaseConnection.R")

shinyServer(function(input, output) {
  
  #从微博表中取出符合检索条件的信息
  weiboList <- reactive({
    con <- initialConnection()
    query <- dbSendQuery(con, 
                         statement = paste("select weiboID,text,Time,weiboZFS,weiboPLS,weiboDZS from weiboinfo where Time >= '", 
                                           as.character(input$sDate), "'", 
                                           "and Time <= '", 
                                           as.character(input$eDate), "'",
                                           "and HashTag like '%", input$hashTag, "%'",
                                           sep = ""))
    trans <- fetch(query)
    dbDisconnect(con)
    colnames(trans) <- c("微博ID", "微博内容", "发布时间", "转发数", "评论数", "点赞数")
    trans
  })
  
  #制作微博表
  output$weiboTable <- renderDataTable(weiboList(), options = list(pageLength = 5))
  
  #由微博ID取出转发信息
  forwardInfoTable <- reactive({
    con <- initialConnection()
    query <- dbSendQuery(con, statement = 
                           paste("select origin_un,forward_un,forward_time,sentiment from forwardinfo where weibo_id = '", 
                                 input$queryID, "'", sep = ""))
    trans <- fetch(query)
    dbDisconnect(con)
    trans
  })
  
  #由微博ID取出评论信息
  relyInfoTable <- reactive({
    con <- initialConnection()
    query <- dbSendQuery(con, statement = 
                           paste("select comment_Sentiment from replyinfo where weiboID = '", 
                                 input$queryID, "'", sep = ""))
    trans <- fetch(query)
    dbDisconnect(con)
    trans
  })
  
  #转发传播图
  output$plot1 <- renderPlot({
    
    makeTransGraph(forwardInfoTable())
    
  })
  
  #转发时间曲线
  output$plot2 <- renderUI({
    
    makeTimeline(forwardInfoTable())
    
  })
  
  #评论情感分析
  output$plot3 <- renderUI({
    
    makeEmotionChart(relyInfoTable())
    
  })
  
})