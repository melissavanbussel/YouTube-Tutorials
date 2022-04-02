# Install package
# install.packages("image.darknet", repos = "https://bnosac.github.io/drat")
# Load package
library(image.darknet)

# Set working directory 
setwd("C:/Users/16138/Documents/YouTube/Image Recognition")

# Classify
darknet_model <- image_darknet_model(type = "classify",
                                     model = "tiny.cfg",
                                     weights = system.file(package = "image.darknet", "models", "tiny.weights"),
                                     labels = system.file(package = "image.darknet", "include", "darknet", "data", "imagenet.shortnames.list"))
image_darknet_classify(file = "C:/Users/16138/Documents/YouTube/Image Recognition/Beagle.jpg",
                       object = darknet_model)

# Detect
darknet_model <- image_darknet_model(type = "detect",
                                     model = "tiny-yolo-voc.cfg",
                                     weights = system.file(package = "image.darknet", "models", "tiny-yolo-voc.weights"),
                                     labels = system.file(package = "image.darknet", "include", "darknet", "data", "voc.names"))
image_darknet_detect(file = "C:/Users/16138/Documents/YouTube/Image Recognition/Beagle.jpg",
                     object = darknet_model)
