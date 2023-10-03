library(survival)
library(survminer)
library(dplyr)
library(survcomp)

data2<-read.csv("data/uploaded9.csv")
size <- rexp(585,1)
ddtr <- cbind(time = data2[, "time"], event = data2[, "status"], score = size)


perf <- sbrier.score2proba(data.tr = data.frame(ddtr), data.ts = data.frame(ddtr), method = "cox")
perf
print (perf)
plot(x = perf$time, y = perf$bsc, xlab = "Time (days)", ylab = "Brier score", type = "l")
return (plot)


perf1 <- concordance.index(x = size, surv.time = data2[,"time"], surv.event = data2[, "status"], method = "noether",na.rm = TRUE)
print(perf1[1:5])
return (perf1)


perf2 <- D.index(x = size, surv.time = data2[,"time"], surv.event = data2[, "status"], na.rm = TRUE)
print(perf2[1:6])



perf3 <- hazard.ratio(x = size, surv.time = data2[,"time"], surv.event = data2[, "status"], na.rm = TRUE)
print(perf3[1:6])



