library(tidyverse)
theme_set(theme_minimal())

# Quelle: https://homepages.thm.de/~mgrh46/projekte/charts
charts = read_csv2("https://homepages.thm.de/~mgrh46/res/download/charts/charts.csv") %>%
  filter(pos <= 10) %>%
  mutate(year = str_sub(date, -4,-1),
         decade = paste0(str_sub(year, 1,3), "0s"),)

# Top artists
artists = charts %>%
  group_by(artist) %>%
  summarise(weeks = n(), songs = n_distinct(title), years = n_distinct(year))

artists

artists %>%
  top_n(songs, n = 20) %>%
  ggplot(aes(y = reorder(artist, songs), x = songs, fill = artist))+
  geom_col(show.legend = F)+
  labs(x = "# of top 10 songs", y = "", title = "Top artists",
       subtitle = "Who had the most top 10 hits in Germany?")

# Aufgaben:
# 1. Balken farbig pro Interpret
# 2. Punkt- statt Balkendiagramm
# 3. Wochen in den Charts oder Jahre mit Top 10 Hits


# Diversity
diversity_per_year = charts %>%
  group_by(decade, year) %>%
  summarise(n_artists = n_distinct(artist),
            n_songs = n_distinct(title))

diversity_per_year

diversity_per_year %>%
  ggplot(aes(x = year, y = n_songs))+
  geom_point()+
  geom_line(group=1)+
  scale_x_discrete(breaks = seq(1975, 2025, 5))
