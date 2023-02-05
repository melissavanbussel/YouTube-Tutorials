# reticulate::py_install("markovify")
# reticulate::py_module_available("markovify")
# remotes::install_github("abresler/markovifyR")

# Load the markovifyR package (R package)
library(markovifyR)

# Create the model
model <- generate_markovify_model(input_text = c("Melissa likes R programming the best",
                                                 "Comparatively, Melissa likes programming in Python a bit less",
                                                 "Some people prefer programming in Python over R programming"),
                                  markov_state_size = 2)

# Generate the new text
text <- markovify_text(markov_model = model)
