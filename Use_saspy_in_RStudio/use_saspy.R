# Install the saspy (Python) package ------------------

# Load reticulate (R) package
library(reticulate) 

# Check if Python installation is visible
py_available(TRUE)  

# Install saspy
py_install("saspy", pip = TRUE)

# Check if saspy is available
py_module_available("saspy")

# Use saspy -------------------------------------------

library(reticulate) # If not already done
saspy <- import("saspy")
sas_sess <- saspy$SASsession(cfgname = "winlocal")  

# Use the penguins dataset from the palmerpenguins package
library(palmerpenguins)

# Make R data frame visible to SAS connection
sas_sess$dataframe2sasdata(df = penguins,
                           table = "sas_penguins")

# Manipulate the data frame in SAS
submit_sas <- sas_sess$submit("proc freq data=sas_penguins; tables species * island / out=work.my_results; run;")

# Bring the results back into R
penguins_freqs <- sas_sess$sasdata2dataframe("my_results")

# Import pandas (Python package) to be used in R
pd <- import("pandas", convert = FALSE)

# Drop the PERCENT column from the penguins_freqs data frame, using pandas (Python package)
penguins_freqs <- pd$DataFrame(data = penguins_freqs)
penguins_freqs <- penguins_freqs$drop("PERCENT", axis = 1)

# Create ggplot 
py_to_r(penguins_freqs) %>%
  ggplot(aes(y = COUNT, x = species)) +
  geom_bar(aes(fill = species), stat = "identity") +
  facet_wrap(~island)
