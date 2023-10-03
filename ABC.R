library(randomForest)
library(rpart)


fitness <- function(solution) {
  
  rf <- randomForest(x = data[, solution], y = labels)
  accuracy <- mean(predict(rf, data[, solution]) == labels)
  return(accuracy)
}


abc <- function(data, labels, population_size, max_iterations) {
  population <- matrix(sample(1:ncol(data), population_size, replace = TRUE), nrow = population_size, ncol = ncol(data))
  
  best_solution <- NULL
  best_fitness <- -Inf
  
  
  for (i in 1:max_iterations) {
    
    employed_bees <- population
    for (j in 1:population_size) {
      
      new_solution <- employed_bees[j, ] + rnorm(ncol(data), mean = 0, sd = 0.1)
      
      new_fitness <- fitness(new_solution)
      if (new_fitness > fitness(employed_bees[j, ])) {
        employed_bees[j, ] <- new_solution
      }
    }
    
    
    onlooker_bees <- sample(employed_bees, population_size, replace = TRUE)
    for (j in 1:population_size) {
      
      new_solution <- onlooker_bees[j, ] + rnorm(ncol(data), mean = 0, sd = 0.1)
      
      new_fitness <- fitness(new_solution)
      if (new_fitness > fitness(onlooker_bees[j, ])) {
        onlooker_bees[j, ] <- new_solution
      }
    }
    
    
    scout_bees <- matrix(sample(1:ncol(data), population_size, replace = TRUE), nrow = population_size, ncol = ncol(data))
    for (j in 1:population_size) {
      
      new_fitness <- fitness(scout_bees[j, ])
      
        if (new_fitness > fitness(scout_bees[j, ])) {
        scout_bees[j, ] <- new_solution
      }
    }
    
   
    best_fitness_index <- which.max(fitness(population))
    if (fitness(population[best_fitness_index, ]) > best_fitness) {
      best_solution <- population[best_fitness_index, ]
      best_fitness <- fitness(population[best_fitness_index, ])
    }
    
   
    population <- cbind(population[, 1:(best_fitness_index - 1)], scout_bees, population[, (best_fitness_index + 1):ncol(population)])
  }
  
  
  return(best_solution)
}



data <- read.csv("data/uploaded4.csv", header = TRUE)
a=rev(names(data))[1]
labels=data$a
data=select(data, -a)

best_solution <- abc(data, labels, population_size = 100, max_iterations = 100)

datanew <-data[,c(best_solution)]
datalast <-data[n]
datab <- cbind(datanew,datalast)
write.csv(datab,'data/newdatasetabc.csv')

