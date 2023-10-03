library(h2o)
library(hmeasure)
library(ParBayesianOptimization)
library(pROC)
h2o.init()

data1 <- read.csv("data/uploaded2.csv")
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


scoringFunction <-function(hidden_opt,epochs_opt,input_dropout_ratio_opt)
{
  
  return(
    list(
      Score = min(hidden_opt,epochs_opt,input_dropout_ratio_opt)
    ))
  
}

hyper_params <- list(hidden_opt = c(50,100),   
                     epochs_opt = c(50,60),
                     input_dropout_ratio_opt = c(0.6,0.9))   


ScoreResult <- bayesOpt(
  FUN = scoringFunction,
  bounds = hyper_params,
  initPoints = 4,
  iters.n = 2,
  iters.k = 1,
  acq = "ei",
  gsPoints = 10,
  parallel = FALSE,
  verbose = 1) 


best_params <- list(getBestPars(ScoreResult,N=1))


dl1<-h2o.deeplearning(x=x, y=y,activation="RectifierWithDropout",training_frame = train, hidden=as.integer(best_params[[1]]$hidden_opt),epochs=best_params[[1]]$epochs_opt,input_dropout_ratio=best_params[[1]]$input_dropout_ratio_opt,nfolds = nfolds,
                      fold_assignment = "Modulo",
                      keep_cross_validation_predictions = TRUE) 


perf <- h2o.performance(dl1, newdata = test)
print(perf)
a<-h2o.auc(perf)
print(a)
