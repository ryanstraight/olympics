# Doing the neural net to determine medal
# Using the neuralnet library
library(neuralnet)
library(beepr)
library('ProjectTemplate')
library(forcats)
library(caret)
library(grDevices)
library(here)
load.project()

# Get rid of the NAs
nn_prep2 <- top_five_with_medals %>%
  drop_na() %>% 
  select(region, sex, age, height, weight, year, medal) %>%
  relocate(medal) %>% 
  mutate(
    gold_winner = case_when(
      medal == "Gold" ~ 1,
      TRUE ~ 0
    )
  )

# Make the gold_winner vector
gold_winner <- nn_prep2$gold_winner

# Unfactor year
nn_prep2$year <- as.numeric(paste(nn_prep2$year))

# Make sex 0/1
nn_prep2$sex <- as.numeric(nn_prep2$sex)-1

# Normalize the data
maxs2 <- apply(nn_prep2[,3:7], 2, max)
mins2 <- apply(nn_prep2[,3:7], 2, min)

# Get the scaled data
scaled_data2 <- as_tibble(scale(nn_prep2[,3:7], center = mins2, scale = maxs2 - mins2))

# Get the sex back in the scaled data
nn_ready2 <- cbind(gold_winner, scaled_data2)


# Now we use nn_ready for the rest
# Create a split
split2 <- caTools::sample.split(nn_ready2$gold_winner, SplitRatio = 0.70)

# Split based off of split Boolean Vector
nn_train2 <- subset(nn_ready2, split == TRUE)
nn_test2 <- subset(nn_ready2, split == FALSE)

# Create neural network function
feats2 <- names(scaled_data2)

# Concatenate strings
f2 <- paste(feats2,collapse= " + ")
f2 <- paste('gold_winner ~', f2)

# As a formula
f2 <- as.formula(f2)

# Get the net going
nn2 <- beep_on_error(neuralnet(f2,nn_train2,hidden = c(3, 3), linear.output = FALSE, stepmax=1e7), sound = "wilhelm"); beep(3)

# Compute predictions off test set
predicted_nn_values2 <- neuralnet::compute(nn2, nn_test2[2:5])

# Results?
head(predicted_nn_values2$net.result)

# Round that
predicted_nn_values2$net.result <- sapply(predicted_nn_values2$net.result, round, digits = 0)

# Create the table
nn_table2 <- table(nn_test2$gold_winner, predicted_nn_values2$net.result)
nn_table2

# Let's take a look at it!
plot(nn2)

#Confusion matrix to get the stats
nn_gold_cm <- confusionMatrix(nn_table2)


