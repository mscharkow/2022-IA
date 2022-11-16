library(tidyverse)
library(magick)
library(traktok)
options(cookiefile = "tt_cookie.txt")

source("03-Bildanalyse/_common.R")

# Example 1
get_nsfw("https://cdn.fansshare.com/images/menshealth/mens-health-february-men-health-cover-model-1939993168.jpg")

# Example 2
tt_nsfw = traktok::tt_json("https://www.tiktok.com/tag/fittok")$ItemModule %>%
  map("video") %>%
  map_chr("cover")  %>%
  set_names(.) %>%
  map_df(get_nsfw, .id = "cover_url")

tt_nsfw %>%
  filter(conf > 50) %>%
  select(label, conf, cover_url)
