library(C50)

dectreeB <- top_ten_with_medals %>%
  select(-notes) %>% 
  mutate(year = as.numeric(year)) %>%
  mutate(adult = ifelse(age >= "17", "Adult", "Minor")) %>% 
  filter(year >= "1970")

dectreeB$adult <- as_factor(dectreeB$adult)

# Attempting a decision tree to predict medal in the past 25 years
seq_len(5)
sample(seq_len(5), 3)
sample_sizeB <- floor(0.8 * nrow(dectreeB))
training_indexB <- sample(seq_len(nrow(dectreeB)), size = sample_sizeB)
trainB <- dectreeB[training_indexB,]
testB <- dectreeB[-training_indexB,]
medal_predictorsB <- as.factor(c('sex', 'region', 'adult'))
treemodelB <- C5.0(x = trainB[,medal_predictorsB], y = trainB$medal)

# Look at the model
#summary(treemodelB)

# Save the plot
#plot(treemodelB)

