# Making graph of medals by country
library('ProjectTemplate')
load.project()
library(ggplot2)
library(here)


medal_counts_by_region <- medal_counts_by_region %>%
  group_by(region) %>% 
  mutate(total_attempts = sum(n), na.rm = TRUE)
  
medal_counts_by_region$region <- factor(medal_counts_by_region$region) %>% 

fct_reorder(medal_counts_by_region$region, medal_counts_by_region$total_attempts, .desc = TRUE)
  
top_half_medal_attempts <- medal_counts_by_region %>%
  group_by(medal) %>%
  filter(n >= mean(n), na.rm = TRUE) %>%
  ungroup() %>% 
  mutate(region = fct_reorder(region, total_attempts)) %>% 
  mutate(medal = fct_relevel(medal, "Gold", "Silver", "Bronze", "none")) %>% 
  ggplot(aes(x=region, y=n, fill=medal)) +
    geom_col() +
    coord_flip() +
    scale_fill_manual(values = c("gold4", "gray70", "darkorange4", "gray20")) +
    ggtitle("All medals throughout the Olympics") +
    labs(y = "Athletes attempting medals", x = "Region") +
    theme(plot.title = element_text(hjust = 0.5),
      axis.text.y = element_text(size=6))

top_half_medal_attempts

ggsave(here("graphs", "allmedalattempts.png"))
dev.off()



# Mapping number of participants over time
