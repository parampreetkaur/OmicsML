library(h2o)
library(hmeasure)
library(ParBayesianOptimization)
library(pROC)
h2o.init()

data1 <- read.csv("data/uploadedrf.csv")
r<-nrow(data1)


train.index = sample(r,floor(0.70*r))

train1= (data1[train.index,])
test1 = (data1[-train.index,])

write.csv(train1,'data/apptrain.csv',row.names = F)
write.csv(test1,'data/apptest.csv',row.names=F)

train <- h2o.importFile("data/apptrain.csv")
test <- h2o.importFile("data/apptest.csv")

testA <- as.numeric(h2o.importFile("data/apptest.csv"))


y<-rev(names(data1))[1]

x <- setdiff(names(train), y)


train[, y] <- as.factor(train[, y])
test1 <- (as.factor(test[, y]))


nfolds <- 10


scoringFunction2 <-function(ntrees_opt,max_depth_opt,min_rows_opt)
{
  
  
  return(
    list(
      Score = min(ntrees_opt,max_depth_opt,min_rows_opt)
    ))
  
}

hyper_params_rf <-list(ntrees_opt=c(50,70),
                       max_depth_opt= c(30,40),
                       min_rows_opt=c(50,100))

ScoreResult2 <- bayesOpt(
  FUN = scoringFunction2,
  bounds = hyper_params_rf,
  initPoints = 5,
  iters.n = 2,
  iters.k = 1,
  acq = "ei",
  gsPoints = 10,
  parallel = FALSE,
  verbose = 1) 



best_params <- list(getBestPars(ScoreResult2,N=1))


rf1 <- h2o.randomForest(x = x,
                        y = y,
                        training_frame = train,
                        ntrees = as.integer(best_param2[[1]]$ntrees_opt),
                        max_depth = as.integer(best_param2[[1]]$max_depth_opt),
                        min_rows = best_param2[[1]]$min_rows_opt,
                        nfolds = nfolds,
                        fold_assignment = "Modulo",
                        keep_cross_validation_predictions = TRUE,
                        seed = 1)


perf <- h2o.performance(rf1, newdata = test)
print(perf)
