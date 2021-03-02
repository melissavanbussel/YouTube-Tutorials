# Set working directory
# setwd("C:/Users/16138/Documents/School/STAT5703/ICA")

# Load packages
library(fastICA)
library(tuneR)
library(seewave)
library(audio)

# Load files in
signal1 <- readWave("artificially_mixed1.wav")
signal2 <- readWave("artificially_mixed2.wav")

# Save sampling rates
samp_rate1 <- signal1@samp.rate
samp_rate2 <- signal2@samp.rate

# Plot the waves
plot(signal1)
plot(signal2)

# Keep just the actual signal
signal1 <- signal1@left
signal2 <- signal2@left

# Check which one is shorter
length_of_shorter <- min(length(signal1), length(signal2))

# Combine the audio files into one matrix (required for fastICA function)
signal_comb <- cbind(signal1[1:length_of_shorter], signal2[1:length_of_shorter])

# Use fastICA function to separate the signals into the 2 original sources
separated <- fastICA(signal_comb, n.comp = 2, row.norm = FALSE)

# Extract new sounds
separated_1 <- separated$S[, 1] / max(separated$S[, 1])
separated_2 <- separated$S[, 2] / max(separated$S[, 2])

# Play sounds
play(separated_1)
play(separated_2)

# Save the new files
savewav(separated_1, f = samp_rate1, file = "separated_example1.wav")
savewav(separated_2, f = samp_rate2, file = "separated_example2.wav")
