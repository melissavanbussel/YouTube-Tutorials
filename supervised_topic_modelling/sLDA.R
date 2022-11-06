# Set-up -----------------------------------------------

# Load packages
library(rsample)
library(tidyverse)
library(cld2)
library(tidytext)
library(lda)

# Load data
profs <- read.csv("Rate My Professors Reviews - Updated.csv")

# Set seed for reproducibility
set.seed(2022)

# Split dataset into two
profs_split <- initial_split(profs)
profs <- training(profs_split)
for_prediction <- testing(profs_split)

# Prepare dataset ------------------------------------

# Keep only the variables that will be used for modelling
profs <- profs %>% 
  select(Quality, Difficulty, Comment)

# Rename variables
profs <- profs %>%
  rename(rating = Quality,
         difficulty = Difficulty,
         comment = Comment)

# Remove French reviews
profs <- profs %>%
  mutate(language = detect_language(comment, plain_text = FALSE)) %>%
  filter(language == "en") %>%
  select(-language)

# Convert to lowercase, remove punctuation and special characters, remove stop words
profs <- profs %>%
  mutate(review_num = row_number()) %>%
  unnest_tokens(output = word, input = comment) %>%
  anti_join(stop_words) %>%
  group_by(review_num) %>% 
  mutate(comment = paste(word, collapse = " ")) %>%
  ungroup() %>% 
  select(-word) %>% 
  distinct()
  
# Fix review number variable
profs <- profs %>% 
  select(-review_num) %>% 
  mutate(review_num = row_number())

# Perform sLDA ------------------------------------

# Create input that is in the format the model is expecting
sLDA_input <- lexicalize(profs$comment)

# Create model
slda_mod <- slda.em(documents = sLDA_input$documents,
                    K = 8,
                    vocab = sLDA_input$vocab,
                    num.e.iterations = 100,
                    num.m.iterations = 2,
                    alpha = 1, 
                    eta = 0.1,
                    params = sample(c(-1, 1), 8, replace = TRUE),
                    variance = var(profs$rating),
                    annotations = profs$rating,
                    method = "sLDA")

# Extract top words for each of the topics
topics <- slda_mod$topics %>%
  top.topic.words(num.words = 5, by.score = TRUE) %>%
  apply(2, paste, collapse = ", ")

# Extract model coefficients for each topic
coefs <- data.frame(coef(summary(slda_mod$model)))
coefs <- cbind(coefs, topics = factor(topics,
                                      topics[order(coefs$Estimate, coefs$Std..Error)]))
coefs <- coefs[order(coefs$Estimate),]

# Visualize top words per topic
coefs %>% ggplot(aes(topics, Estimate, colour = Estimate)) + 
  geom_point() + 
  geom_errorbar(width = 0.5, 
                aes(ymin = Estimate - 1.96 * Std..Error, 
                    ymax = Estimate + 1.96 * Std..Error)) +
  coord_flip() + theme_bw()

# Add an explanatory variable to the model ----------------

# Generate model coefficients without using slda.em function
df <- t(slda_mod$document_sums) / colSums(slda_mod$document_sums)
df <- cbind(df, profs$rating)
df <- data.frame(df)
colnames(df) <- c(paste0("topic", 1:8), "rating")
lmod <- lm(rating ~ . -1, data = df)
coef(lmod)

# Add another explanatory variable to the model
df <- t(slda_mod$document_sums) / colSums(slda_mod$document_sums)
df <- cbind(df, profs$rating, profs$difficulty)
df <- data.frame(df)
colnames(df) <- c(paste0("topic", 1:8), "rating", "difficulty")
lmod <- lm(rating ~ . -1, data = df)
coef(lmod)

# Prediction on unseen data ---------------------------
profs <- for_prediction

# Keep only the variables that will be used for modelling
profs <- profs %>% 
  select(Quality, Difficulty, Comment)

# Rename variables
profs <- profs %>%
  rename(rating = Quality,
         difficulty = Difficulty,
         comment = Comment)

# Remove French reviews
profs <- profs %>%
  mutate(language = detect_language(comment, plain_text = FALSE)) %>%
  filter(language == "en") %>%
  select(-language)

# Convert to lowercase, remove punctuation and special characters, remove stop words
profs <- profs %>%
  mutate(review_num = row_number()) %>%
  unnest_tokens(output = word, input = comment) %>%
  anti_join(stop_words) %>%
  group_by(review_num) %>% 
  mutate(comment = paste(word, collapse = " ")) %>%
  ungroup() %>% 
  select(-word) %>% 
  distinct()

# Fix review number variable
profs <- profs %>% 
  select(-review_num) %>% 
  mutate(review_num = row_number())

# Create input that is in the format the model is expecting
sLDA_input <- lexicalize(profs$comment)

# Do prediction using first model (no explanatory variables aside from topics)
yhat <- slda.predict(sLDA_input$documents,
                     slda_mod$topics,
                     slda_mod$model,
                     alpha = 1,
                     eta = 0.1)

# Do prediction using second model (difficulty variable as an explanatory variable in addition to topics)
new_document_sums <- slda.predict.docsums(sLDA_input$documents, slda_mod$topics,
                                          alpha = 1, eta = 0.1)
df <- t(new_document_sums) / colSums(new_document_sums)
df <- cbind(df, profs$rating, profs$difficulty)
df <- data.frame(df)
colnames(df) <- c(paste0("topic", 1:8), "rating", "difficulty")
yhat <- predict(lmod, newdata = df)
