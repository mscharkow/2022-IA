# http://varianceexplained.org/r/trump-tweets/

library(tidytext)
library(lubridate)
library(tidyverse)
theme_set(theme_minimal())

load(url("http://varianceexplained.org/files/trump_tweets_df.rda"))

tweets <- trump_tweets_df %>%
  select(id, statusSource, text, created) %>%
  extract(statusSource, "source", "Twitter for (.*?)<") %>%
  filter(source %in% c("iPhone", "Android"))

# Tageszeiten
tweets %>%
  count(source, hour = hour(with_tz(created, "EST"))) %>%
  mutate(percent = n / sum(n)) %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line()+
  labs(x = "Hour of day (EST)",
       y = "Proportion of tweets",
       color = "")

# Bilder
tweets %>%
    filter(!str_detect(text, '^"')) %>%
    count(source,
          picture = ifelse(str_detect(text, "t.co"),
                           "Picture/link", "No picture/link")) %>%
  ggplot(aes(source, n, fill = picture)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "", y = "Number of tweets", fill = "")

# Hashtags
tweets %>%
  mutate(hashtag = str_detect(text, "#\\w+")) %>%
  group_by(source) %>%
  summarise(mean(hashtag))


# Textstatistik
words = tweets %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>%
  unnest_tokens(word, text, token="tweets")

words %>%
  anti_join(stop_words) %>%
  count(word, sort = T)

words %>%
  anti_join(stop_words) %>%
  count(source, word) %>%
  spread(source, n, fill = 0) %>%
  ungroup() %>%
  mutate_each(funs((. + 1) / sum(. + 1)), -word) %>%
  mutate(logratio = log2(Android / iPhone)) %>%
  arrange(-abs(logratio)) %>%
  group_by(source = ifelse(logratio > 0, "Android", "iPhone")) %>%
  slice(1:10) %>%
  ggplot(aes(x = reorder(word, logratio), y = logratio, fill=source))+
  geom_col()+
  coord_flip()+
  labs(x = "term")


# Sentiment analysis
words %>%
  left_join(sentiments) %>%
  count(source, sentiment) %>%
  na.omit() %>%
  group_by(source) %>%
  mutate(prop = n/sum(n))

afinn = get_sentiments("afinn")
nrc = get_sentiments("nrc")

words %>%
  left_join(afinn) %>%
  group_by(source, created = floor_date(created, unit = "month")) %>%
  summarise(sentiment = mean(value, na.rm = T)) %>%
  ggplot(aes(x = created, y = sentiment, color = source))+
  geom_line()+
  ylim(-1,3)

words %>%
  left_join(nrc) %>%
  count(source, sentiment) %>%
  na.omit %>%
  group_by(source) %>%
  mutate(prop = n/sum(n)) %>%
  ggplot(aes(x = reorder(sentiment, prop), y = prop, fill = source ))+
  geom_col(position=position_dodge())

# Topic Model
library(stm)

dfm = words %>%
  anti_join(stop_words) %>%
  count(id, word, sort = T) %>%
  cast_dfm(id, word, n)

topic_model = stm(dfm, K = 12)

td_beta <- tidy(topic_model)
td_beta

# Examine the topics
td_beta %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  ggplot(aes(reorder(term, beta), beta)) +
  geom_col() +
  facet_wrap(~ topic, scales = "free") +
  coord_flip()
