# Load packages
library(MASS)       # For Boston dataset
library(tidyverse)  # For data visualization
library(earth)      # For MARS
library(caret)      # For parameter tuning

# Set seed to ensure reproducibility
set.seed(2021)

# Examine the dataset
# ?Boston # to view the documentation for the dataset
Boston %>% 
  ggplot(aes(x = lstat, y = medv) ) +
  geom_point() +
  geom_smooth(method = "lm")
Boston %>% 
  ggplot(aes(x = lstat, y = medv) ) +
  geom_point() +
  geom_smooth()

# Create train/test split (80/20)
train_indices <- sample(1:nrow(Boston), size = floor(0.8 * nrow(Boston)),
                        replace = FALSE)
boston_train <- Boston[train_indices,]
boston_test <- Boston[-train_indices,]

# Check documentation for earth function
# ?earth
# x, y, degree, nprune
# Example: earth(x, y, degree = 2, nprune = 10)

# Define our values for x and y 
x <- boston_train[, -14]
y <- boston_train[, 14]

# Create a parameter tuning "grid"
parameter_grid <- floor(expand.grid(degree = 1:4, nprune = seq(5, 50, by = 5)))

# Perform cross-validation
cv_mars_boston <- train(x = x,
                        y = y,
                        method = "earth",
                        metric = "RMSE",
                        trControl = trainControl(method = "cv", number = 10),
                        tuneGrid = parameter_grid)

# Visualize the results from the cross validation on the parameter tuning 
# nprune is along x-axis (maximum number of terms)
# the fill aesthetic (colours) and shape aesthetic are "degree" (max. degree of interaction term)
ggplot(cv_mars_boston) 

# Use the best model to predict response variable for the test set 
mars_predict <- predict(object = cv_mars_boston$finalModel, 
                        newdata = boston_test)

# Get the SSE 
mars_sse <- sum((boston_test$medv - mars_predict)^2)

# Get the MAE (mean absolute error)
mars_mae <- mean(abs(boston_test$medv - mars_predict))

# Plot the residuals
plot(boston_test$medv - mars_predict, 
     main = "Residuals for MARS model", 
     xlab = "Observation number in test set", 
     ylab = "Residual")
