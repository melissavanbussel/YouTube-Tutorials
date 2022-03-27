# Load packages
library(tidyverse)
library(reticulate)
# NOTE: You might need to run reticulate::py_config() before you can load the fuzzywuzzyR package
library(fuzzywuzzyR)

# Load Python modules
DIFFLIB <- reticulate::import("difflib")
POLYFUZZ <- reticulate::import("polyfuzz")

# Set working directory
setwd("C:/Users/16138/Documents/YouTube/fuzzy_string_matching")

# Load CSV file
rooms <- read.csv("room_type.csv")

# Define two vectors of strings to be matched
from_vec <- unique(rooms$Expedia)
to_vec <- unique(rooms$Booking.com)

# Create function that gets the best matches for two vectors of strings, using difflib
get_best_matches <- function(from_vec, to_vec) {
  
  # Non-vectorized version of the function
  get_best_match <- function(from_string, to_vec) {
    return(DIFFLIB$get_close_matches(from_string, to_vec, 1L, cutoff = 0))
  }
  
  # Vectorize the function
  unlist(lapply(from_vec, function(from_vec) get_best_match(from_vec, to_vec)))
}
# difflib_matches <- get_best_matches(from_vec, to_vec)

# Create function that computes the similarity score between two sets of strings, using difflib
get_score <- function(strings1, strings2) {
  return(SequenceMatcher$new(strings1, strings2)$ratio())
}
get_score <- Vectorize(get_score)
# difflib_scores <- get_score(from_vec, difflib_matches)

# Use polyfuzz to perform fuzzy string matching
# EditDistance
editdistance_results <- POLYFUZZ$PolyFuzz("EditDistance")$match(from_vec, to_vec)$get_matches()

# TF-IDF
tfidf_results <- POLYFUZZ$PolyFuzz("TF-IDF")$match(from_vec, to_vec)$get_matches()
