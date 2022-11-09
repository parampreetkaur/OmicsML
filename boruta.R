library(caret)
library(Boruta)
data=read.csv("data/uploaded4.csv")
n=length(data)
boruta_output <- Boruta(label ~ ., data=data, doTrace=0) 
boruta_signif <- getSelectedAttributes(boruta_output, withTentative = TRUE)
print(boruta_signif)
datanew <-data[,c(boruta_signif)]
datalast <-data[n]
datab <- cbind(datanew,datalast)
write.csv(datab,'data/newdatasetboruta.csv')

