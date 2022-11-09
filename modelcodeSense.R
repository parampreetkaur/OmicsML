library(h2o)
library(hmeasure)
library(ParBayesianOptimization)
h2o.init()

data2 <- read.csv("data/uploaded1.csv")
r<-nrow(data2)


train.index = sample(r,floor(0.70*r))
train1= (data2[train.index,])
test1 = (data2[-train.index,])

write.csv(train1,'data/trainstaccfmetab.csv',row.names = F)
write.csv(test1,'data/teststaccfmetab.csv',row.names=F)

train <- h2o.importFile("data/trainstaccfmetab.csv")
test <- h2o.importFile("data/teststaccfmetab.csv")


y<-rev(names(data2))[1]

x <- setdiff(names(train), y)


train[, y] <- as.factor(train[, y])
test[, y] <- as.factor(test[, y])



nfolds <- 10


dl1<-h2o.deeplearning(x=x, y=y,activation="RectifierWithDropout",training_frame = train, hidden=c(190,63,21,7),epochs=50,input_dropout_ratio=0.1,nfolds = nfolds,
                      fold_assignment = "Modulo",
                      keep_cross_validation_predictions = TRUE ) 



my_gbm <- h2o.gbm(x = x,
                  y = y,
                  training_frame = train,
                  distribution = "bernoulli",
                  ntrees = 50,
                  learn_rate =0.2,
                  max_depth = 3,
                  sample_rate = 0.9,
                  col_sample_rate = 0.7,
                  nfolds = nfolds,
                  fold_assignment = "Modulo",
                  keep_cross_validation_predictions = TRUE,
                  seed = 1)




rf1 <- h2o.randomForest(x = x,
                        y = y,
                        training_frame = train,
                        ntrees = 50,
                        max_depth = 30,
                        min_rows = 50,
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

