# If you don't already have Python 3.10 installed, install it and then create a virtual environment that uses Python 3.10
# install_python(version = "3.10:latest")
# virtualenv_create(envname = "openai", version = "3.10:latest")
# virtualenv_install(envname = "openai", packages = "openai")

# Tell the reticulate package to use the "openai" virtual environment that was created above
reticulate::use_virtualenv("openai")

# Load the reticulate package
library(reticulate)

# Load the openai Python package
openai <- import("openai")

# Generate an image using OpenAI's Images API (DALL-E models)
response <- openai$Image$create(
  prompt = "A white siamese cat",
  n = 1L, 
  size = "1024x1024"
)

# Extract the URL where the generated image can be downloaded (URL is only valid for 1h)
response$data[[1]]$url
