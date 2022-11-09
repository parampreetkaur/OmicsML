

library(caret)
library(randomForest)
library(funModeling)
library(tidyverse)
library(GA)
source("ga.R")


data=read.csv("data/uploaded7.csv")
n=length(data)

a=rev(names(data))[1]


data_y=as.factor(data$a)
data_x=select(data, -a)

param_nBits=ncol(data_x)
col_names=colnames(data_x)


ga_GA_1 = ga(fitness = function(vars) custom_fitness(vars = vars, 
                                                     data_x =  data_x, 
                                                     data_y = data_y, 
                                                     p_sampling = 0.7), 
             type = "binary", 
             crossover=gabin_uCrossover,  
             elitism = 3, 
             pmutation = 0.03, 
             popSize = 50, 
             nBits = param_nBits, 
             names=col_names, 
             run=5, 
             maxiter = 50, 
             monitor=plot, 
             keepBest = TRUE, 
             parallel = T, 
             seed=84211 
)



summary(ga_GA_1)
saveRDS(ga_GA_1, "genetic.rds")
p<-readRDS("genetic.rds")


best_vars_ga=col_names[p@solution[1,]==1]

best_vars_ga
print (best_vars_ga)

datanew <-data[,c(best_vars_ga)]
datalast <-data[n]
datab <- cbind(datanew,datalast)
write.csv(datab,'data/newdatasetga.csv')


get_accuracy_metric(data_tr_sample = data_x, target = data_y, best_vars_ga)