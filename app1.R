options(shiny.maxRequestSize = 200*1024^2)
library(h2o)
library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(DT)
library(reticulate)

library(survival)      
library(survminer)
library(dplyr)
library(survcomp) 

source_python("naremove.py")
source_python("kNN.py")
source_python("anova.py")
source_python("fireflyalgo.py")

h2o.init()


ui <-dashboardPage(skin="red",
                   dashboardHeader(title="OmicsML"),     
                   dashboardSidebar(
                     sidebarMenu(
                       
                       fileInput("file4", "1.Upload csv file for Pre-processing",
                                 multiple = FALSE,
                                 accept = c("text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")), 
                       menuItem("Techniques",
                       menuItem("NAremove",tabName="NAremove",icon=icon("tree"),selected=FALSE),
                       menuItem("kNNImpute",tabName="kNNImpute",icon=icon("tree"))
                      
                       ),
                       
                       fileInput("file2", "2.Upload csv file for Feature Selection",
                                 multiple = FALSE,
                                 accept = c("text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")), 
                       menuItem("Feature Selection",
                                menuItem("ABC",tabName="ABC",icon=icon("tree"),selected=FALSE),  
                                menuItem("ANOVA",tabName="ANOVA",icon=icon("tree")),              
                                menuItem("Firefly",tabName="Firefly",icon=icon("tree"))
                       ),
                       
                       
                       fileInput("file3", "3.Upload csv file for Prediction",              
                                 multiple = FALSE,
                                 accept = c("text/csv",
                                            "text/comma-separated-values,text/plain",
                                            ".csv")),
                       
                       menuItem("Models",
                                menuItem("BSense",tabName="BSense",icon=icon("tree"),selected=FALSE),                       
                                menuItem("BDNN",tabName="GDNN",icon=icon("tree"))                
                     
                       ),
                       
                       fileInput("file5", "4.Upload csv file for Survival Analysis",
                                        multiple = FALSE,
                                        accept = c("text/csv",
                                                   "text/comma-separated-values,text/plain",
                                                   ".csv")),
                              
                              menuItem("Survival",tabName="Survival",icon=icon("tree"),selected=FALSE)
                     )
                   ),
                   
                   
                   dashboardBody(
                     tabItems(
                       tabItem("NAremove",
                               fluidPage(
                                 tabBox(
                                   id = "tabset8",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Pre-processed dataset",
                                     box(withSpinner(verbatimTextOutput("result9")), width = 12)
                                     
                                   ),
                                   tabPanel(
                                     "Download Pre-processed dataset",
                                     box(downloadButton("downloadData7", "Download Dataset(.csv file)"), width = 12)
                                     
                                   )
                                 )) 
                       ),
                       
                       tabItem("kNNImpute",
                               fluidPage(
                                 tabBox(
                                   id = "tabset7",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Pre-processed dataset",
                                     box(withSpinner(verbatimTextOutput("result8")), width = 12)
                                     
                                   ),
                                   tabPanel(
                                     "Download Pre-processed dataset",
                                     box(downloadButton("downloadData6", "Download Dataset(.csv file)"), width = 12)
                                     
                                   )
                                 )) 
                       ), 
                       
                       tabItem("ABC",
                               fluidPage(
                                 tabBox(
                                   id = "tabset5",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Selected Features",
                                     box(withSpinner(verbatimTextOutput("result5")), width = 12)
                                   ),
                                   tabPanel(
                                     "Download Selected Features dataset",
                                     box(downloadButton("downloadData3", "Download Dataset(.csv file)"), width = 12)
                                   )
                                 )) ),
                       
                       tabItem("ANOVA",
                               fluidPage(
                                 tabBox(
                                   id = "tabset4",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Selected Features",
                                     box(withSpinner(verbatimTextOutput("result3")), width = 12)
                                     
                                   ),
                                   tabPanel(
                                     "Download Selected Features dataset",
                                     box(downloadButton("downloadData1", "Download Dataset(.csv file)"), width = 12)
                                     
                                   )
                                 )) 
                       ), 
                        
                       tabItem("Firefly",
                               fluidPage(
                                 tabBox(
                                   id = "tabset7",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Selected Features",
                                     box(withSpinner(verbatimTextOutput("result7")), width = 12)
                                   ),
                                   tabPanel(
                                     "Download Selected Features dataset",
                                     box(downloadButton("downloadData5", "Download Dataset(.csv file)"), width = 12)
                                     
                                   )
                                 )) ), 
                                                        
                       
                       tabItem("BSense",
                               fluidPage(
                                 tabBox(
                                   id = "tabset2",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Results",
                                     box(withSpinner(verbatimTextOutput("result1")), width = 12)
                                   ),
                                   tabPanel(
                                     "Plot",
                                     box(withSpinner(plotOutput("plotr1")), width = 12)
                                     
                                   )
                                 )) ),
                       
                       tabItem("GDNN",
                               fluidPage(
                                 tabBox(
                                   id = "tabset3",
                                   height = "1000px",
                                   width = 12,
                                   tabPanel(
                                     "Results",
                                     box(withSpinner(verbatimTextOutput("result2")), width = 12)
                                   ),
                                   tabPanel(
                                     "Plot",
                                     box(withSpinner(plotOutput("plotr2")), width = 12)
                                     
                                   )
                                 )) ),
                          tabItem("Survival",
                                  fluidPage(
                                   tabBox(
                                    id = "tabset9",
                                   height = "1000px",
                                  width = 12,
                                   tabPanel(
                                    "Results",
                                   box(withSpinner(verbatimTextOutput("result10")), width = 12)
                         
                              ),
                                tabPanel(
                                 "Brier score curve",
                                  box(withSpinner(plotOutput("plotr3")), width = 12)
                                
                                ),
                               tabPanel(
                                 "Kaplan Meier curve",
                                 box(withSpinner(plotOutput("plotr4")), width = 12)
                                 
                               )
                               
                           )) 
                         )
                       
                     )
                   ))

server <-function(input,output){
  
  output$result9 = renderPrint({
    req(input$file4)
    data12 <- read.csv(input$file4$datapath, stringsAsFactors = TRUE)             
    write.csv(data12,'data/uploaded10.csv')        
    e<-preprocess1()
    return (e)
  })
  
  data12 <- read.csv("data/missing_drop_integratednew.csv")        
  output$downloadData7 <- downloadHandler(                                                            
    filename = function() {                                                                            
      paste("data-", Sys.Date(), ".csv", sep="")                                                      
    },                                                                                                 
    content = function(file) {                                                                         
      write.csv(data12,file)                                                                           
    }                                                                                                  
  )                                                                                                    
  
  
  output$result8 = renderPrint({
    req(input$file4)
    data7 <- read.csv(input$file4$datapath, stringsAsFactors = TRUE)
    write.csv(data7,'data/uploaded8.csv')
    d<-preprocess()
    return (d)
  })
  data7 <- read.csv("data/missing_integratednew.csv") 
  output$downloadData6 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(data7,file)
    }
  )
  
  
  output$result5 = renderPrint({
    req(input$file2)
    data4 <- read.csv(input$file2$datapath, stringsAsFactors = TRUE)
    write.csv(data4,'data/uploaded4.csv')
    
    source("ABC.R")
    sink("output$result5")
    return (boruta_signif)
    
  })
  data2 <- read.csv("data/newdatasetabc.csv") 
  output$downloadData3 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(data2,file)
    }
  )
  
  
  output$result3 = renderPrint({
    
    req(input$file2)
    data4 <- read.csv(input$file2$datapath, stringsAsFactors = TRUE)
    write.csv(data4,'data/uploaded3.csv')
    a<-featurefxnanova()
    return (a)
  })
  data1 <- read.csv("data/newdatasetanova.csv") 
  output$downloadData1 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(data1,file)
    }
  )
  
  output$result7 =renderPrint({
    req(input$file2)
    data6 <- read.csv(input$file2$datapath, stringsAsFactors = TRUE)
    write.csv(data6,'data/uploaded6.csv')
    c<-featurefxn4()
    return (c)
  })
  data4 <- read.csv("data/newdatasetfire.csv") 
  output$downloadData5 <- downloadHandler(
    filename = function() {
      paste("data-", Sys.Date(), ".csv", sep="")
    },
    content = function(file) {
      write.csv(data4,file)
    }
  )
  
  
  output$result1 = renderPrint({
    req(input$file3)
    data2 <- read.csv(input$file3$datapath, stringsAsFactors = TRUE)
    write.csv(data2,'data/uploaded1.csv')
    source("bsensemodelcode.R")
    sink("output$result1")
    return(perf)
  })
  output$plotr1 =renderPlot({
    req(input$file3)
    data2 <- read.csv(input$file3$datapath, stringsAsFactors = TRUE)
    write.csv(data2,'data/uploaded1.csv')
    source("bsensemodelcode.R")
    plot(perf,valid=T,type='roc') 
    sink("output$plotr1")
  })
  output$result2 = renderPrint({
    req(input$file3)
    data3 <- read.csv(input$file3$datapath, stringsAsFactors = TRUE)
    write.csv(data3,'data/uploaded2.csv')
    source("BDNNmodelcode.R")
    sink("output$result2")
    return(best_deep_perf1)
  })
  output$plotr2 =renderPlot({
    req(input$file3)
    data3 <- read.csv(input$file3$datapath, stringsAsFactors = TRUE)
    write.csv(data3,'data/uploaded2.csv')
    source("BDNNmodelcode.R")
    plot(perf,valid=T,type='roc') 
    sink("output$plotr2")
  })
  
   output$result10 = renderPrint({
     req(input$file5)
     data8 <- read.csv(input$file5$datapath, stringsAsFactors = TRUE)
     write.csv(data8,'data/uploaded9.csv')
     source("survive.R")
     sink("output$result10")
     return (perf)
       })
      output$plotr3 =renderPlot({
        req(input$file5)
        data9 <- read.csv(input$file5$datapath, stringsAsFactors = TRUE)
        write.csv(data9,'data/uploaded9.csv')
        source("survive_plot.R")
        plot(x = perf$time, y = perf$bsc, xlab = "Time (days)", ylab = "Brier score", type = "l") 
        sink("output$plotr3")
      })
     output$plotr4 =renderPlot({
       req(input$file5)
       data10 <- read.csv(input$file5$datapath, stringsAsFactors = TRUE)
       write.csv(data10,'data/uploaded9.csv')
       source("survive_plot1.R")
       
       plot(fit1, data = data3, pval = TRUE)
       sink("output$plotr4")
     })
     
 
}

shinyApp(ui,server)
