library(survival)
library(survminer)
library(dplyr)
library(survcomp)

  
label=read.csv("data/label.csv")
  data2<-read.csv("data/uploaded9.csv")
 
  data3<-select(data2,-c('survival_time','survival_status'))
 
  surv_object <- (Surv(time = data2$survival_time, event = data2$survival_status))
  
  
  
  fit1 <- survfit(surv_object ~ label, data = data3)
  summary(fit1)
  