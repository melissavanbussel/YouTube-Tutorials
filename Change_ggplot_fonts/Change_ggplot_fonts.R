# Load packages 
library(showtext)   # For changing fonts in a ggplot
library(ggplot2)    # For creating ggplots

# Add Calibri and Comic Sans MS fonts to R
font_add(family = "Calibri", regular = "Calibri.ttf")
font_add(family = "ComicSansMS", regular = "Comic.ttf")

# Enable showtext (using default options)
showtext_auto()
# Note: to change resolution, adjust the dpi parameter using the showtext_opts() function.
# For example: showtext_opts(dpi = 300)

# Create example ggplot using Calibri font
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  theme(text = element_text(family = "Calibri")) +
  labs(title = "This is Calibri font")

# Create example ggplot using Comic Sans MS font
ggplot(data = mtcars, aes(x = mpg, y = wt)) +
  geom_point() +
  theme(text = element_text(family = "ComicSansMS")) +
  labs(title = "This is Comics Sans MS font")

# Save most recent plot
ggsave(filename = "change_ggplot_fonts.png", 
       width = 3, height = 4, units = "in")
