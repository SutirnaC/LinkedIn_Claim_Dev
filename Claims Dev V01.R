
library(ggplot2)
library(gganimate)
library(gifski)
library(tidyverse)

set.seed(123)
claims_data <- expand.grid(
  AccidentYear = 2010:2015,
  DevelopmentYear = 1:8
) %>%
  mutate(
    InitialClaims = round(runif(length(unique(AccidentYear)), 3000, 10000))[match(AccidentYear, unique(AccidentYear))],
    DecayFactor = runif(length(unique(AccidentYear)), 0.5, 0.8)[match(AccidentYear, unique(AccidentYear))],
    ReportedClaims = round(InitialClaims * (1 - exp(-DecayFactor * DevelopmentYear)))
  )

p <- ggplot(claims_data, aes(x = DevelopmentYear, y = ReportedClaims, group = AccidentYear, color = as.factor(AccidentYear))) +
  geom_line(size = 1.2) +
  labs(title = "Claims Development Over Time", 
       x = "Development Year", 
       y = "Reported Claims", 
       color = "Accident Year") +
  theme_minimal() +
  transition_reveal(DevelopmentYear)

# Save as GIF
anim_save("claims_development.gif", animation = animate(p, renderer = gifski_renderer()),fps=100, duration=2,nframes=50)

