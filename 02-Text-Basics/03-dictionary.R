library(tidyverse)
library(tidytext)
theme_set(theme_bw()+theme(legend.position = "top"))

txt = read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-10-18/stranger_things_all_dialogue.csv') %>%
  mutate(season = as.character(season),
         episode = as.character(episode),
         ep = paste0(season, ".", episode)) %>%
  group_by(season, episode) %>%
  mutate(runtime = max(end_time) %>% as.integer) %>%
  ungroup() %>%
  filter(!is.na(dialogue)) %>%
  unnest_tokens(word, dialogue)

# Simple dictionary -------------------------------------------------------

swearing = c("shit", "bullshit", "crap")
txt %>%
  filter(word %in% swearing) %>%
  count(season, ep) %>%
  group_by(season) %>%
  summarise(m_swearing = mean(n), sd_swearing = sd(n))

txt %>%
  filter(word %in% swearing) %>%
  count(season, ep, runtime) %>%
  mutate(swearing_per_minute = n/(runtime/60)) %>%
  ggplot(aes(x = ep, y = swearing_per_minute, color = season))+
  geom_point()+
  geom_line(group = 1)

# Sentiment analysis

get_sentiments("bing")
txt %>%
  left_join(get_sentiments("bing")) %>%
  count(season, sentiment) %>%
  na.omit() %>%
  spread(sentiment, n) %>%
  mutate(net_senti = positive-negative)

get_sentiments("afinn")
txt %>%
  left_join(get_sentiments("afinn")) %>%
  group_by(season, episode) %>%
  summarise(tone = mean(value, na.rm = T)) %>%
  ggplot(aes(x = paste(season,episode, sep="."), y = tone, color = season))+
  geom_line(group = 1)+
  geom_point()

# Sentiment NRC
sent_counts  = txt %>%
  left_join(get_sentiments("nrc")) %>%
  filter(!is.na(sentiment) & !sentiment %in% c("positive", "negative")) %>%
  count(season, ep, sentiment) %>%
  group_by(season, ep) %>%
  mutate(percent = n/sum(n)*100) %>%
  ungroup()

sent_counts %>%
  ggplot(aes(x = ep, y = percent, group = sentiment, color = season))+
  geom_line()+
  geom_point()+
  geom_hline(yintercept = 1/8*100, linetype = "dashed")+
  facet_wrap("sentiment", ncol = 2)
