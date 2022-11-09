library(survival)
library(survminer)
library(dplyr)
library(survcomp)


data2<-read.csv("data/uploaded9.csv")
size <- rexp(585,1)
ddtr <- cbind(time = data2[, "survival_time"], event = data2[, "survival_status"], score = size)

perf <- sbrier.score2proba(data.tr = data.frame(ddtr), data.ts = data.frame(ddtr), method = "cox")
perf
