# Load packages
library(httr2)
library(tidyverse)

# Define access tokens
access_token_openai <- Sys.getenv("OPENAI_API_KEY")
access_token_gitlab <- Sys.getenv("GITLAB_API_KEY")

# Define base URLs
base_url_openai <- "https://api.openai.com/v1"
base_url_gitlab <- "https://gitlab.com/api/v4"

# Define endpoints
endpoint_openai <- "/images/generations"
endpoint_gitlab <- "/projects/53405032/issues"

# Define request
req_openai <- request(base_url_openai) %>% 
  req_url_path_append(endpoint_openai)
req_gitlab <- request(base_url_gitlab) %>% 
  req_url_path_append(endpoint_gitlab)

# Provide access token via header
headers_openai <- req_openai %>%
  req_auth_bearer_token(access_token_openai)

headers_gitlab <- req_gitlab %>%
  req_headers(
    `PRIVATE-TOKEN` = access_token_gitlab
  )

# Create response body
resp_body_openai <- headers_openai %>%
  req_body_json(
    list(prompt = "A cute baby sea otter")
  )

# Perform response 
req_perform_openai <- resp_body_openai %>% 
  req_perform()
req_perform_gitlab <- headers_gitlab %>%
  req_perform()

# Extract results from the response
results_openai <- req_perform_openai %>%
  resp_body_json()
results_gitlab <- req_perform_gitlab %>%
  resp_body_json()

# Explore results
results_openai$data[[1]]$url
results_gitlab[[1]]$milestone$title
results_gitlab[[1]]$title
results_gitlab[[1]]$time_stats$total_time_spent
