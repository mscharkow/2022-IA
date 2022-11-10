library(tidyverse)
library(tidytext)
theme_set(theme_bw())

txt = read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv') %>%
  mutate(season = as.character(season),
         episode = as.character(episode),
         ep = paste0(season, ".", episode)) %>%
  group_by(season, episode) %>%
  mutate(runtime = max(end_time) %>% as.integer) %>%
  ungroup() %>%
  filter(!is.na(dialogue)) %>%
  unnest_tokens(word, dialogue)

# Word statistics ---------------------------------------------------------

# Top words
txt %>%
  count(word, sort = T)

# Stop word removal
txt %>%
  count(word, sort = T) %>%
  anti_join(stop_words)

# Keyness mit TF-IDF
txt %>%
  count(season, word) %>%
  bind_tf_idf(word, season, n) %>%
  group_by(season) %>%
  slice_max(tf_idf, n = 5)

# Text statistics ---------------------------------------------------------

txt %>%
  count(season, ep, runtime) %>%
  mutate(words_per_minute = n/(runtime/60)) %>%
  summary()

# Type-Token-Ratio
txt %>%
  group_by(ep) %>%
  summarise(tokens = n(), types = n_distinct(word)) %>%
  mutate(ttr = types/tokens)