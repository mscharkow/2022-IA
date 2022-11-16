library(tidyverse)
library(magick)
source("03-Bildanalyse/_common.R")

# Example 1
image_read("https://cdn.pixabay.com/photo/2020/02/29/22/41/demonstration-4891291_1280.jpg") %>%
  image_resize("400x")

get_labels("https://cdn.pixabay.com/photo/2020/02/29/22/41/demonstration-4891291_1280.jpg") %>%
  print(n=30)


# Example 2

pix = rvest::read_html("https://www.worldpressphoto.org/collection/photocontest/2022/winners") %>%
  rvest::html_elements(".winners-new__card img") %>% rvest::html_attr("src")

pix

set.seed(1234)

labels = pix %>%
  paste0("https://www.worldpressphoto.org", .) %>%
  sample(20) %>%
  na.omit() %>%
  set_names(.) %>%
  purrr::map_df(get_labels, .id = "image")

labels

labels %>%
  count(label, sort = T)

labels %>%
  filter(label == "Fire")

image_read("https://www.worldpressphoto.org/getmedia/140911d8-3eaf-495e-ab4e-c744b277a2d9/WPP_2022Contest_Southeast-Asia-and-Oceania_STO_Matthew-Abbott_AJ.jpg") %>%
  image_resize("400x")
