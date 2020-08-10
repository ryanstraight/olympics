# Basic summary
summary(olympics)

# Let's see who has the medals
medal_counts_by_region <- olympics %>%
  group_by(region) %>% 
  count(medal, sort = TRUE) %>% 
  drop_na() %>% 
  ungroup()

# Now group by medals and sort the countries
gold_medals <- medal_counts_by_region %>% 
  filter(medal == "Gold") %>% 
  group_by(medal) %>% 
  count(region, sort = TRUE) %>% 
  ungroup()

# Silver
silver_medals <- medal_counts_by_region %>% 
  filter(medal == "Silver") %>% 
  group_by(medal) %>% 
  count(region, sort = TRUE) %>% 
  ungroup()
  
# Bronze
bronze_medals <- medal_counts_by_region %>% 
  filter(medal == "Bronze") %>% 
  group_by(medal) %>% 
  count(region, sort = TRUE) %>% 
  ungroup()

# None
no_medals <- medal_counts_by_region %>% 
  filter(medal == "none") %>% 
  group_by(medal) %>% 
  count(region, sort = TRUE) %>% 
  ungroup()


##
#
# Let's make some decades for analysis
#
olympics <- olympics %<>%
  mutate(decade=case_when(
    year %in% 1890:1899 ~ "1890s",
    year %in% 1900:1909 ~ "1900s",
    year %in% 1910:1919 ~ "1910s",
    year %in% 1920:1929 ~ "1920s",
    year %in% 1930:1939 ~ "1930s",
    year %in% 1940:1949 ~ "1940s",
    year %in% 1950:1959 ~ "1950s",
    year %in% 1960:1969 ~ "1960s",
    year %in% 1970:1979 ~ "1970s",
    year %in% 1980:1989 ~ "1980s",
    year %in% 1990:1999 ~ "1990s",
    year %in% 2000:2009 ~ "2000s",
    year %in% 2010:2019 ~ "2010s"
  ))
  
olympics$decade <- as_factor(olympics$decade)


########
# 
summary_over_time <- olympics %>%
  filter(sport != c("Art Competitions", "Other")) %>%
  group_by(year, season) %>%
  summarize(
    Athletes = length(unique(id)),
    Nations = length(unique(noc)),
    Events = length(unique(event))
  )
