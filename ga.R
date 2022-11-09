custom_fitness <- function(vars, data_x, data_y, p_sampling)
{
  
  ix=get_sample(data_x, percentage_tr_rows = p_sampling)
  data_2=data_x[ix,]
  data_y_smp=data_y[ix]
  
  
  names=colnames(data_2)
  names_2=names[vars==1]
 
  data_sol=data_2[, names_2]
  
  
  roc_value=get_roc_metric(data_sol, data_y_smp, names_2)
  
 
  q_vars=sum(vars)
  
  
  fitness_value=roc_value/q_vars
  
  return(fitness_value)
}

get_roc_metric <- function(data_tr_sample, target, best_vars) 
{
  
  
  fitControl <- trainControl(method = "cv", 
                             number = 3, 
                             summaryFunction = twoClassSummary,
                             classProbs = TRUE)
  
  data_model=select(data_tr_sample, one_of(best_vars))
  
  mtry = sqrt(ncol(data_model))
  tunegrid = expand.grid(.mtry=round(mtry))
  
  fit_model_1 = train(x=data_model, 
                      y= target, 
                      method = "rf", 
                      trControl = fitControl,
                      metric = "ROC",
                      tuneGrid=tunegrid
  )
  
  metric=fit_model_1$results["ROC"][1,1]
  
  return(metric)
}




get_accuracy_metric <- function(data_tr_sample, target, best_vars) 
{
  data_model=select(data_tr_sample, one_of(best_vars))
  
  fitControl <- trainControl(method = "cv", 
                             number = 3, 
                             summaryFunction = twoClassSummary)
  
  data_model=select(data_tr_sample, one_of(best_vars))
  
  mtry = sqrt(ncol(data_model))
  tunegrid = expand.grid(mtry=round(mtry))
  
  fit_model_1 = train(x=data_model, 
                      y= target, 
                      method = "rf",
                      tuneGrid = tunegrid)
  
  
  
  metric=fit_model_1$results["Accuracy"][1,1]
  return(metric)
}  