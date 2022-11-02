library(tidyverse)

# Source https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-09-29

beyonce_lyrics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-29/beyonce_lyrics.csv')
taylor_swift_lyrics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-29/taylor_swift_lyrics.csv')

beyonce_lyrics
taylor_swift_lyrics

b_lyrics = beyonce_lyrics %>%
  group_by(artist_name, song_name) %>%
  summarise(lyrics = paste(line, collapse = "\n")) %>%
  ungroup() %>%
  rename(Artist = artist_name, Title = song_name, Lyrics = lyrics)

d_both = bind_rows(b_lyrics, taylor_swift_lyrics) %>%
  mutate(n_chars = str_length(Lyrics))
d_both

write_tsv(d_both, "both_lyrics.tsv")

# Bonus
d_both %>%
  group_by(Artist) %>%
  summarise(n_songs = n(), chars_per_song = mean(n_chars))
