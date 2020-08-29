# Building the kmeans clustering model
library(tidyverse)
library(animation)
library(gridExtra)
library(here)
set.seed(74993049)

# Rescale data to new dataframe
o_scale <- olympics %>% 
  mutate(
    age = scale(age),
    weight = scale(weight),
    height = scale(height),
    sex = as.factor(sex)) %>%
  select(age, weight, height, sex) %>% 
  drop_na()

# Let's check the data
summary(o_scale)

# Run k means function
cluster1 <- kmeans(o_scale[2:3], 3, nstart = 25)
summary(cluster1)

# Animate the process
#saveGIF({  kmeans.ani(o_scale[2:3], 3)}, movie.name = "cluster_1.gif", interval = 1, nmax = 50, ani.width = 600)

# Create a ggplot that scatters height and weight with sex fill
scale_sex <- o_scale %>% ggplot(aes(x = weight, y = height, col=as.factor(sex))) +
                geom_point() +
                labs(color = "Sex\n") +
                scale_color_manual(values = c("red", "skyblue"))



