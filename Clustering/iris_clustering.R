# Agglomerative Hierarchical Clustering
# Compute distance matrix (exclude non-numeric variables)
iris_dist <- dist(iris[, -5], method = "euclidean")

# Use "complete" linkage
hc_complete <- hclust(iris_dist, method = "complete")

# Plot dendrogram
plot(hc_complete, cex = 0.75)
rect.hclust(hc_complete, k = 3)

# Load package for visualizing dendrograms
library(dendextend)

# Convert to dendrogram object
hc_complete_dend <- as.dendrogram(hc_complete)

# Plot dendrogram
plot(colour_branches(hc_complete_dend, k = 3))

# View cluster labels (and compare to k-means)
# k-means clustering (exclude non-numeric variables)
# Set seed to ensure reproducibility
set.seed(12)
iris_kmeans <- kmeans(iris[, -5], 3)

# Load package for visualizing the clusters
library(factoextra)

# Agglomerative hierarchical clustering
fviz_cluster(object = list(data = iris,
                           cluster = cutree(hc_complete, k = 3)),
             choose.vars = c(1, 2),
             geom = "point",
             show.clust.cent = FALSE,
             main = "Agglomerative HC - Complete Linkage") +
  theme(legend.position = "none")

# k-Means
fviz_cluster(object = list(data = iris,
                           cluster = iris_kmeans$cluster),
             choose.vars = c(1, 2),
             geom = "point",
             show.clust.cent = FALSE,
             main = "k-Means") +
  theme(legend.position = "none")

# True cluster labels (species)
fviz_cluster(object = list(data = iris,
                           cluster = iris$Species),
             choose.vars = c(1, 2),
             geom = "point",
             show.clust.cent = FALSE,
             main = "True species label") +
  theme(legend.position = "none")
