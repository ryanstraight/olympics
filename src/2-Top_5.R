library('ProjectTemplate')
load.project()

# Attempting a decision tree to predict medal
seq_len(5)
sample(seq_len(5), 3)
sample_size5 <- floor(0.8 * nrow(top_five_with_medals))
training_index5 <- sample(seq_len(nrow(top_five_with_medals)), size = sample_size5)
train5 <- top_five_with_medals[training_index5,]
test5 <- top_five_with_medals[-training_index5,]
medal_predictors5 <- as.factor(c('sex', 'region', 'age'))
model5 <- C5.0(x = train5[,medal_predictors5], y = train5$medal)

# Look at the model
summary(model5)
plot(model5)

