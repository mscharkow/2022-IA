library(tidyverse)
library(tidytext)
theme_set(theme_bw())

stranger_things <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv') %>%
  mutate(season = as.character(season),
         episode = as.character(episode),
         ep = paste0(season, ".", episode)) %>%
  group_by(season, episode) %>%
  mutate(runtime = max(end_time) %>% as.integer) %>%
  ungroup()

stranger_things

# Average runtimes per season
stranger_things %>%
  group_by(season) %>%
  summarise(m = mean(runtime)/60)

# Average lines per episode
stranger_things %>%
  count(ep) %>%
  summary()

# Tidy text ---------------------------------------------------------------

stranger_things %>%
  unnest_characters(character, dialogue)

stranger_things %>%
  unnest_ngrams(bigram, dialogue, n = 2)

txt = stranger_things %>%
  filter(!is.na(dialogue)) %>%
  unnest_tokens(word, dialogue)

txt

# Document Term Matrix
txt %>%
  count(ep, word) %>%
  filter(n > 10) %>%
  spread(word, n,  fill = 0)
