# Code used in this tutorial video: https://www.youtube.com/watch?v=Ck10_VtN_88
# Load packages
library(h2o)
library(mlbench)

# Explore dataset
data("BreastCancer")

# Remove ID column 
tumours <- BreastCancer[, -1]

# Turn ordered factors back to numeric variables
tumours$Cl.thickness <- as.numeric(tumours$Cl.thickness)
tumours$Cell.size <- as.numeric(tumours$Cell.size)
tumours$Cell.shape <- as.numeric(tumours$Cell.shape)
tumours$Marg.adhesion <- as.numeric(tumours$Marg.adhesion)
tumours$Epith.c.size <- as.numeric(tumours$Epith.c.size)

# Begin h2o instance
# You'll need Java installed (versions supported by h2o: 8-13)
h2o.init()

# Convert input into H2OFrame 
# NOTE: In practice, you'd want to split this into two: a training set and a test set
# You'd want to train the model using the train data, and evaluate model performance on the test set.
tumours_h2o <- as.h2o(tumours)

# Take a look at the contents of the H2OFrame
h2o.describe(tumours_h2o)

# Create neural network using H2O
h2o_nn <- h2o.deeplearning(x = 1:9,
                           y = 10, 
                           training_frame = tumours_h2o,
                           nfolds = 5, 
                           standardize = TRUE,
                           activation = "Rectifier",
                           hidden = c(5, 200),
                           seed = 2021)

# Look at performance of model
h2o.performance(h2o_nn)

# Use model to predict classes
h2o_predictions <- h2o.predict(object = h2o_nn, 
                               newdata = tumours_h2o)

# Explore predictions
h2o_predictions <- as.data.frame(h2o_predictions)

# Shutdown H2O instance
h2o.shutdown()
