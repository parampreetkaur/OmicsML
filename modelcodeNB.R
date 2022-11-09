library(h2o)
library(hmeasure)
h2o.init()
data3 <- read.csv("data/uploaded2.csv")

r<-nrow(data3)

train.index = sample(r,floor(0.70*r))

trainm= (data3[train.index,])
testm = (data3[-train.index,])

write.csv(trainm,'data/atrainstac.csv',row.names = F)
write.csv(testm,'data/ateststac.csv',row.names=F)

data <- h2o.importFile("data/atrainstac.csv")
test <- h2o.importFile("data/ateststac.csv")



y<-rev(names(data3))[1]

x <- setdiff(names(data), y)


data[, y] <- as.factor(data[, y])
test[, y] <- as.factor(test[, y])

ss <- h2o.splitFrame(data, seed = 1)
train <- ss[[1]]
valid <- ss[[2]]



nfolds <- 10


my_nb <- h2o.naiveBayes(x = x,
                        y = y,
                        training_frame = train,
                        laplace = 0,
                        nfolds = nfolds,
                        seed = 1234)
perf <- h2o.performance(my_nb, newdata = test)
print(perf)


