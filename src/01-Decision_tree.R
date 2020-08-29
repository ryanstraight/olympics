library(C50)

# Attempting a decision tree to predict medal
seq_len(5)
sample(seq_len(5), 3)
sample_size <- floor(0.8 * nrow(top_ten_with_medals))
training_index <- sample(seq_len(nrow(top_ten_with_medals)), size = sample_size)
train <- top_ten_with_medals[training_index,]
test <- top_ten_with_medals[-training_index,]
medal_predictors <- as.factor(c('medal', 'region', 'age'))
treemodel <- C5.0(x = train[,medal_predictors], y = train$sex)

# Look at the model
#summary(treemodel)

# Save the plot
#plot(treemodel, vertical=FALSE)

