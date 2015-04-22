library(shiny)

shinyUI(fluidPage(
  titlePanel("这就是传播图"),
  
  #整体网页侧边栏模式
  sidebarLayout(
    #侧边栏设置
    sidebarPanel(
      helpText("输入检索选项"),
      
      dateInput('sDate',
                label = "请在此选择检索起点日期",
                value = Sys.Date() - 10, #默认值
                max = Sys.Date(), #最大值
                format = "yyyy/mm/dd",
                startview = 'month', language = 'zh-CN', weekstart = 1),
      
      br(),
      
      dateInput('eDate',
                label = "请在此选择检索终点日期",
                value = Sys.Date(),
                max = Sys.Date(),
                format = "yyyy/mm/dd",
                startview = 'month', language = 'zh-CN', weekstart = 1),
      
      br(),
      
      textInput("hashTag", label = "请在此输入检索主题"),
      
      submitButton("提交")
    ),
    
    #网页主题设置
    mainPanel(
      dataTableOutput('weiboTable'),
      
      tags$hr(),
      
      textInput("queryID", label = "请复制需查询的微博ID", value = "a"),
      
      submitButton("提交"),
      
      tags$hr(),
      
      plotOutput("plot1"),
      
      tags$hr(),
      
      htmlOutput("plot2"),
      
      tags$hr(),
      
      htmlOutput("plot3")
    )
  )
)
)