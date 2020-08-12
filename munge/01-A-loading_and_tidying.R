# tidy up the titles
athlete_events <- athlete_events %>% clean_names()
noc_regions <- noc_regions %>% clean_names()

# Join up athlete_events and noc_regions to get a nice country name
olympics <- as_tibble(athlete_events %>% left_join(noc_regions, by = "noc"))

# Switch to factors
olympics <- olympics %>%
  mutate(across(c("sex", "team", "noc", "games", "year", "sport", "city", "region", "season"), factor))

# Replace NAs in "medal" with "None"
olympics$medal <- olympics$medal %>% 
  replace_na("none") %>% 
  as_factor()

# There are way too many sports and a few only happened a couple times. Pare those down to the top 50
olympics$sport <- olympics$sport %>%
  fct_lump_n(n = 51)

