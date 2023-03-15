# Install dependencies
# install.packages(c("devtools", "openai"))
# devtools::install_github("isinaltinkaya/gptchatteR")

# Load package that allows you to interface with ChatGPT
library(gptchatteR)

# Replace the below with your OpenAI API key
chatter.auth("YOUR API KEY GOES HERE")

# Initiate chat session with ChatGPT; type ?chatter.create for additional options
chatter.create()

# Talk to ChatGPT 
response <- chatter.chat("What is the meaining of life?", return_response = TRUE)

# Extract the response from ChatGPT
response$choices[[1]]
