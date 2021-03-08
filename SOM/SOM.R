# Load package
library(kohonen)

# See structure of the iris dataset
str(iris)

# Prepare the data for the SOM function
iris_SOM <- as.matrix(scale(iris[, -5]))

# Create grid to be used for the SOM 
iris_grid <- somgrid(xdim = 5, ydim = 5, topo = "hexagonal")

# Set seed to ensure reproducibility 
set.seed(2021)

# Use the SOM function 
iris_SOM_model <- som(X = iris_SOM, 
                      grid = iris_grid)

# Plot our results 
# Plot type 1: counts
plot(iris_SOM_model, type = "counts")

# Plot type 2: heatmap 
plot(iris_SOM_model, type = "property", 
     property = getCodes(iris_SOM_model)[, 2],
     main = colnames(iris)[2])

# Plot type 3: fan diagram 
plot(iris_SOM_model, type = "codes")










