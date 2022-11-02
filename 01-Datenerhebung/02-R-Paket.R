library(tidyverse)
library(traktok)
library(magick)
options(cookiefile = "tt_cookie.txt")

ed = traktok::tt_user_videos("https://www.tiktok.com/@edsheeran")
ed

ed_video1 = traktok::tt_videos("https://www.tiktok.com/@edsheeran/video/7160722817980304646")
ed_video1

ed_comments1 = traktok::tt_comments("https://www.tiktok.com/@edsheeran/video/7160722817980304646")
ed_comments1

write_tsv(ed_comments1, "ed_comments1.tsv")

# Bonus
traktok::tt_json("https://www.tiktok.com/@billieeilish")$ItemModule %>%
  map("video") %>%
  map_chr("cover")  %>%
  magick::image_read() %>%
  magick::image_resize("320x") %>%
  magick::image_write_gif("tiktok_billieeilish.gif", delay = 1)
