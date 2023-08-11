# Load R packages
library(reticulate)
library(imager)

# py_module_available("autocrop")
# py_install("autocrop", pip = TRUE)

# Import Python packages
autocrop <- import("autocrop")
PIL <- import("PIL")
numpy <- import("numpy")

# Crop image
cropped_image <- autocrop$Cropper()$crop("obama.jpg")

# Rotate image
cropped_image <- rotate_xy(cimg(array(data = cropped_image, c(500, 500, 1, 3))),
                           angle = 90,
                           cx = 250,
                           cy = 250)

# Preview image 
plot(as.raster(cropped_image))

# Save the image
save.image(cropped_image, file = "cropped.jpg")
