library(tidyverse)
library(jsonlite)

#https://github.com/AndreasFischer1985/tagesschau-api

jsonlite::fromJSON("https://www.tagesschau.de/api2/news")

tagesschau = jsonlite::fromJSON("https://www.tagesschau.de/api2/news")$news %>%
  as_tibble()
tagesschau

tagesschau %>%
  select(title, date, url = shareURL) %>%
  write_tsv("tagesschau.tsv")

sport = fromJSON("https://www.tagesschau.de/api2/news?ressort=sport")$news %>%
  as_tibble
sport

# Bonus Tags
sport %>% unnest(tags) %>% count(tag, sort = T)

# Bonus Bilder
sport$teaserImage$mittelgross1x1$imageurl %>%
  na.omit() %>%
  head(25) %>%
  magick::image_read() %>%
  magick::image_montage(tile = 5, geometry = 'x120+2+2')


