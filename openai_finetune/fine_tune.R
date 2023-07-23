# Extract data -----------------------------------------------------------------
# Downloaded from: http://ai.stanford.edu/~amaas/data/sentiment/?ref=hackernoon.com

library(tidyverse)

# Get the file names of all files in the "positive" training data
pos_reviews <- list.files(paste0(getwd(), "/pos"))

# Get the file names of all files in the "positive" training data
neg_reviews <- list.files(paste0(getwd(), "/neg"))

# Initialize data frame 
reviews <- data.frame()
reviews <- reviews %>% 
  add_column(classification = NA) %>% 
  add_column(text = NA)

# Read in each text file 
for (i in 1:length(pos_reviews)) {
  temp_df <- read_file(paste0(getwd(), "/pos/", pos_reviews[i]))
  temp_df <- data.frame(classification = "positive",
                        text = temp_df)
  reviews <- rbind(reviews, temp_df)
}
for (i in 1:length(neg_reviews)) {
  temp_df <- read_file(paste0(getwd(), "/neg/", neg_reviews[i]))
  temp_df <- data.frame(classification = "negative",
                        text = temp_df)
  reviews <- rbind(reviews, temp_df)
}

# Rename columns 
reviews <- reviews %>% 
  rename(prompt = text,
         completion = classification)

# Reorder columns 
reviews <- reviews %>% 
  relocate(prompt, .before = completion)

# Save results
saveRDS(reviews, file = "reviews.RDa")

# Sample 5% 
reviews <- reviews %>% 
  sample_n(size = 1250)

# Convert to JSON file
library(rjson)
reviews_json <- toJSON(reviews)
write(reviews_json, "reviews.json")

# Fine tune model --------------------------------------------------------------

library(openai)

# "Upload" the training and validation data created in the terminal
training_info <- upload_file(file = "reviews_prepared_train.jsonl", purpose = "fine-tune")
validation_info <- upload_file(file = "reviews_prepared_valid.jsonl", purpose = "fine-tune")

# Create model
info <- create_fine_tune(
  training_file = training_info$id,
  validation_file = validation_info$id,
  model = "ada",
  compute_classification_metrics = TRUE,
  classification_positive_class = " positive" # Mind space in front
)

# Get model ID 
id <- ifelse(
  length(info$data$id) > 1,
  info$data$id[length(info$data$id)],
  info$data$id
)

# Check status of model
retrieve_fine_tune(fine_tune_id = id)

# Create example prompt to use with trained model
my_prompt <- r"(An Intelligent and well obtained film worth to export! <br /><br />In this exiting and really intelligent movie filmed entirely in Bogotá, you can feel the total meaning of the word "Bluff"(although is a Colombian film, the title is in presented in English); ! <br /><br />The story is about Nicolas Andrade (Federico Lorusso), a photographer who find his girlfriend Margarita (Catalina Aristizabal) having an affair with his boss Pablo Mallarino (Victor Mallarino), owner of a magazine; after this Nicolas is left without girlfriend and without any job. Nicolas revenge to Mallarino consists in following him and obtaining photographs of him with his new affair Alexandra (Carolina Gomez) to blackmail Mallarino in order to obtain money in change for not showing the photographs to Margarita.<br /><br />The story is really intelligent and well related, to the point that you'll understand fully the meaning of the title, the movie shows a thriller with a lot of a comic scenes and characters, resulting in a real pleasure to someone that enjoy the movies focused on a good script.<br /><br />I stand out here that this film is different from the typical Colombian movies that show's some dark and violent image of our beautiful country, which is something really refreshing. Some critics say that this story don't show Colombian typical way of living, so it could be held in any part of the world, i disagree with this: (1) the movie is totally filmed in Bogotá, so you can see streets, and images of the real Colombian capital (i hope that some American people and movie producers watch this so they stop showing Amazonic jungle, or Mexican little towns in Bogota as on some Hollywood movies), (2) the characters, dialogs, accent (with exception from Nicolas that is from Argentina) are totally from here, Rosemary (Veronica Orozco) has an accent typical from Cali, (3) you can also see social and cultural differences from the common people in Bogotá. I hope that all this, plus an English title move people from other countries to watch this masterpiece of Martinez<br /><br />Excellent acting of Veronica Orozco, Luis Eduardo Arango (detective Wilson Montes), Felipe Botero, outstanding as detective Ricardo Perez, and good acting of Mallarino, Catalina Aristizabal and Federico Lorusso.<br /><br />A movie worth to export, that people from around the globe will surely understand and enjoy!, Don't miss this movie 9/10! ->)"

# Use model
my_results <- create_completion(
  model = "ada:ft-personal-2023-07-19-03-21-19",
  prompt = c(my_prompt, my_prompt),
  max_tokens = 1, 
  temperature = 0
)

# Extract results
my_results$choices$text
