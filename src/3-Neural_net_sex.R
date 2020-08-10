# Using the neuralnet library
library(neuralnet)
library(beepr)
library('ProjectTemplate')
library(forcats)
library(caret)
library(grDevices)
library(here)
library(NeuralNetTools)
#load.project()

# To determine if sex can be predicted from region, age, height, weight, year, and gold medal winning

# Get rid of the NAs
nn_prep <- top_five_with_medals %>%
  select(region, sex, age, height, weight, year, medal) %>% 
  filter(medal == "Gold") %>% 
  drop_na()


# Unfactor year
nn_prep$year <- as.numeric(paste(nn_prep$year))


# Convert sex to 0/1
nn_prep$sex_fac <- as.factor(nn_prep$sex)
nn_prep_sex <- as.numeric(nn_prep$sex_fac) -1

# Normalize the data
maxs <- apply(nn_prep[,3:6], 2, max)
mins <- apply(nn_prep[,3:6], 2, min)

# Get the scaled data
scaled_data <- as_tibble(scale(nn_prep[,3:6], center = mins, scale = maxs - mins))

# Get the sex back in the scaled data
nn_ready <- cbind(nn_prep_sex, scaled_data)

# Now we use nn_ready for the rest
# Create a split
split <- caTools::sample.split(nn_ready$nn_prep_sex, SplitRatio = 0.70)

# Split based off of split Boolean Vector
nn_train <- subset(nn_ready, split == TRUE)
nn_test <- subset(nn_ready, split == FALSE)

# Create neural network function
feats <- names(scaled_data)

# Concatenate strings
f <- paste(feats,collapse= " + ")
f <- paste('nn_prep_sex ~', f)

# As a formula
f <- as.formula(f)

# Get the net going
nn <- beep_on_error(neuralnet(f,nn_train,hidden = c(3, 3), linear.output = FALSE, stepmax=1e7), sound = "wilhelm"); beep(3)

# Compute predictions off test set
predicted_nn_values <- neuralnet::compute(nn, nn_test[2:5])

# Results?
head(predicted_nn_values$net.result)

# Round that
predicted_nn_values$net.result <- sapply(predicted_nn_values$net.result, round, digits = 0)

# Create the table
nn_sex_table <- table(nn_test$nn_prep_sex, predicted_nn_values$net.result)
nn_sex_table

# Let's take a look at it!
#plot(nn)
     
# Save the plot in the /graphs/ folder
#png(file = "nn_sex_plot2.png")
#print(plot(nn))
#dev.print(png, here("graphs", "nn_sex_plot.png"), width=600, height=400)
#dev.off()

#Confusion matrix to get the stats
nn_sex_cm <- confusionMatrix(nn_sex_table)


