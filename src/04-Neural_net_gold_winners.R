# Doing the neural net to determine medal
# Using the neuralnet library
library(neuralnet)
library(beepr)
library('ProjectTemplate')
library(forcats)
library(caret)
library(grDevices)
library(here)
set.seed(74993049)
#load.project()

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

# Unfactor year
nn_prep2$year <- as.numeric(paste(nn_prep2$year))

#Factorize gold winner
#nn_prep2$gold_winner <- as.factor(nn_prep2$gold_winner)

# Make the gold_winner vector
gold_winner <- as.numeric(nn_prep2$gold_winner)

# Make sex 0/1
nn_prep$sex_fac <- as.factor(nn_prep$sex)
nn_prep2$sex <- as.numeric(nn_prep2$sex)-1

# Normalize the data
maxs2 <- apply(nn_prep2[,3:7], 2, max)
mins2 <- apply(nn_prep2[,3:7], 2, min)

# Get the scaled data
scaled_data2 <- as_tibble(scale(nn_prep2[,3:7], center = mins2, scale = maxs2 - mins2))

# Get the gold winning back in the scaled data
nn_ready2 <- cbind(gold_winner, scaled_data2)


# Now we use nn_ready2 for the rest
# Create a split
split2 <- caTools::sample.split(nn_ready2$gold_winner,SplitRatio=0.7)

# Split based off of split Boolean Vector
nn_train2 <- subset(nn_ready2, split2 == TRUE)
nn_test2 <- subset(nn_ready2, split2 == FALSE)
save(nn_test2, file = here("data", "nn_test2.Rdata"))

# Create neural network function
feats2 <- names(scaled_data2)

# Concatenate strings
g <- paste(feats2,collapse= " + ")
g <- paste('gold_winner ~', g)

# As a formula
g <- as.formula(g)

# Get the net going
#nn2 <- beep_on_error(neuralnet(g,nn_train2,hidden = c(3, 2), linear.output = FALSE, stepmax=1e7), sound = "wilhelm"); beep(3)

# Cache it so we can just load it later
#save(nn2, file = here("data", "nn2.RData"))

# Load the RData file instead of running the net
load(here("data", "nn2.RData"))
load(here("data", "nn_test2.RData"))

# Compute predictions off test set
predicted_nn_values2 <- neuralnet::compute(nn2, nn_test2[2:6])

# Results?
head(predicted_nn_values2$net.result)

# Round that
predicted_nn_values2$net.result <- sapply(predicted_nn_values2$net.result, round, digits = 0)

# Create the table
nn_table2 <- table(nn_test2$gold_winner, predicted_nn_values2$net.result)
nn_table2

# Let's take a look at it!
plot(nn2)

# Save the plot in the /graphs/ folder
#png(file = "nn2.png")
#print(plot(nn2))
#dev.print(png, here("graphs", "nn2.png"), width=1200, height=800)
#dev.off()

#Confusion matrix to get the stats
nn_gold_cm <- confusionMatrix(nn_table2)
save(nn_gold_cm, file = here("data", "nn_gold_cm.Rdata"))
nn_gold_cm

