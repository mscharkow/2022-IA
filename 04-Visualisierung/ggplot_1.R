library(tidyverse)
theme_set(theme_minimal())

# Quelle: https://github.com/rfordatascience/tidytuesday/tree/master/data/2022/2022-11-01
horror_movies <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2022/2022-11-01/horror_movies.csv') %>%
  mutate(revenue = revenue/1e6, decade = paste0(str_sub(release_date, 1,3), "0s"))
horror_movies

# Most successful movies

horror_movies %>%
  top_n(revenue, n = 10)

horror_movies %>%
  top_n(revenue, n = 10) %>%
  ggplot(aes(x = revenue, y = title))+
  geom_col(fill = "deeppink")+
  labs(x = "Revenue in Million $", y = "", title = "Best horror movies ever")

ggsave("top_horror.png", width = 10, height = 5)

# Aufgaben
# 1. Auswertung nach Bewertung statt Umsatz
# 2. Sortieren nach Bewertung


# ANOVA Beispiel

my_anova = horror_movies %>%
  group_by(decade) %>%
  summarise(mean_ci = mean_cl_normal(vote_average)) %>%
  unnest(mean_ci)

my_anova

my_anova %>%
  ggplot(aes(x = decade, y = y, ymin = ymin, ymax = ymax))+
  geom_pointrange()

# Aufgaben:
# 1. Nach Mittelwert sortieren
# 2. Punkte farbig nach Dekade
# 3. Beschriften
