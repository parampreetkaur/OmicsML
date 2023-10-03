library(h2o)
library(hmeasure)
library(ParBayesianOptimization)
h2o.init()

data2 <- read.csv("data/uploaded1.csv")
r<-nrow(data2)

train.index = sample(r,floor(0.70*r))
train1= (data2[train.index,])
test1 = (data2[-train.index,])

write.csv(train1,'data/trainstac.csv',row.names = F)
write.csv(test1,'data/teststac.csv',row.names=F)

train <- h2o.importFile("data/trainstac.csv")
test <- h2o.importFile("data/teststac.csv")


y<-rev(names(data2))[1]

x <- setdiff(names(train), y)


train[, y] <- as.factor(train[, y])
test[, y] <- as.factor(test[, y])



nfolds <- 10



scoringFunction <-function(hidden_opt,epochs_opt,input_dropout_ratio_opt)
{
  
  
  return(
    list(
      Score = min(hidden_opt,epochs_opt,input_dropout_ratio_opt)
    ))
  
}

scoringFunction1 <-function(learn_rate,max_depth,sample_rate,col_sample_rate)
{
  
  
  return(
    list(
      Score = min(learn_rate,max_depth,sample_rate,col_sample_rate)
    ))
  
}

scoringFunction2 <-function(ntrees_opt,max_depth_opt,min_rows_opt)
{
  
  
  return(
    list(
      Score = min(ntrees_opt,max_depth_opt,min_rows_opt)
    ))
  
}

hyper_params_gbm <- list(learn_rate = c(0.01, 0.2),
                         max_depth = c(2, 3),
                         sample_rate = c(0.9, 1.0),
                         col_sample_rate = c(0.7, 0.8))

hyper_params <- list(hidden_opt = c(50,100),   
                     epochs_opt = c(50,60),
                     input_dropout_ratio_opt = c(0.6,0.9))   

hyper_params_rf <-list(ntrees_opt=c(50,70),
                       max_depth_opt= c(30,40),
                       min_rows_opt=c(50,100))


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

ScoreResult1 <- bayesOpt(
  FUN = scoringFunction1,
  bounds = hyper_params_gbm,
  initPoints = 5,
  iters.n = 2,
  iters.k = 1,
  acq = "ei",
  gsPoints = 10,
  parallel = FALSE,
  verbose = 1) 

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




best_params <- list(getBestPars(ScoreResult,N=1))

best_param1 <-list(getBestPars(ScoreResult1,N=1))

best_param2 <-list(getBestPars(ScoreResult2,N=1))



dl1<-h2o.deeplearning(x=x, y=y,activation="RectifierWithDropout",training_frame = train, hidden=as.integer(best_params[[1]]$hidden_opt),epochs=best_params[[1]]$epochs_opt,input_dropout_ratio=best_params[[1]]$input_dropout_ratio_opt,nfolds = nfolds,
                      fold_assignment = "Modulo",
                      keep_cross_validation_predictions = TRUE ) 



my_gbm <- h2o.gbm(x = x,
                  y = y,
                  training_frame = train,
                  distribution = "bernoulli",
                  ntrees = 50,
                  learn_rate =best_param1[[1]]$learn_rate,
                  max_depth = as.integer(best_param1[[1]]$max_depth),
                  sample_rate = best_param1[[1]]$sample_rate,
                  col_sample_rate = best_param1[[1]]$col_sample_rate,
                  nfolds = nfolds,
                  fold_assignment = "Modulo",
                  keep_cross_validation_predictions = TRUE,
                  seed = 1)


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



ensemble1 <- h2o.stackedEnsemble(x = x,
                                 y = y,
                                 training_frame = train,
                                 base_models = list(dl1,my_gbm,rf1),
                                 metalearner_algorithm = "deeplearning")


perf <- h2o.performance(ensemble1, newdata = test)
perf 
print(perf)
a<-h2o.auc(perf)
print(a)


pred <- h2o.predict(ensemble1, newdata = test)
pred

