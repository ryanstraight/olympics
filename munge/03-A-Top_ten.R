# First let's filter it down to the top 10 medal-winning nations
top_ten <- medal_counts_by_region %>% 
  group_by(region) %>% 
  filter(medal != "none") %>%
  summarise(total_medals = sum(n)) %>% 
  arrange(desc(total_medals)) %>% 
  top_n(10, total_medals)


# Now drop the unused factors
top_ten$region <- droplevels(top_ten$region)

# Make it a character string for the joining
top_ten_regions <- as.character(top_ten$region)

#Let's try to filter Olympics down to the top 10 countries
top_ten_with_medals <- top_ten %>% full_join(olympics, by = "region") %>% 
  group_by(region) %>% 
  filter(medal != "none" & region %in% top_ten_regions) %>% 
  arrange(desc(total_medals)) %>% 
  top_n(10, total_medals) %>% 
  ungroup()

# Get rid of all the other values in the factor list to just have the top 10
#top_ten_with_medals$region <- as.character(top_ten_with_medals$region)
#top_ten_with_medals$region <- as_factor(top_ten_with_medals$region)
top_ten_with_medals$region <- droplevels(top_ten_with_medals$region)
top_ten_with_medals$medal <- droplevels(top_ten_with_medals$medal)



# Let's do a top 5
top_five_regions <- as.character(top_ten$region) %>% 
  head(5L)

top_five_with_medals <- top_ten %>% full_join(olympics, by = "region") %>% 
  group_by(region) %>% 
  filter(medal != "none" & region %in% top_five_regions) %>% 
  arrange(desc(total_medals)) %>% 
  ungroup()

# Drop the unused factor levels
top_five_with_medals$region <- droplevels(top_five_with_medals$region)
top_five_with_medals$medal <- droplevels(top_five_with_medals$medal)
