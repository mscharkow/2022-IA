library(tidyverse)
library(magick)
source("03-Bildanalyse/_common.R")

# Example 1
image_read("https://cdn.pixabay.com/photo/2017/06/20/22/14/man-2425121_1280.jpg") %>%
  image_resize("400x")
get_faces("https://cdn.pixabay.com/photo/2017/06/20/22/14/man-2425121_1280.jpg")

# Example 3
ifp_grad = "https://scontent-frx5-1.xx.fbcdn.net/v/t1.6435-9/72960144_1366520583530158_3250081759533989888_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=730e14&_nc_ohc=y6AEeiYRYPYAX_uPtzp&_nc_ht=scontent-frx5-1.xx&oh=00_AfCHycu_B8u32m9dr0gaZKgij15SeqcQ-4S4h75qflbyRQ&oe=639C29F4"

image_read(ifp_grad) %>% image_resize("800x")
ifp_grad_faces = get_faces(ifp_grad)
ifp_grad_faces

# Gender comparisons
ifp_grad_faces %>%
  add_count(gender) %>%
  group_by(gender, n) %>%
  summarise_at(vars(age, angry:surprised), lst(mean))

# Example 3 (with JSON)

tagesschau = jsonlite::fromJSON("https://www.tagesschau.de/api2/news")$news %>%
  as_tibble()

teaser_images = tagesschau$teaserImage$portraetgrossplus8x9$imageurl
teaser_images

teaser_faces = sample(teaser_images, 30) %>%#
  na.omit() %>%
  purrr::map_df(get_faces)

teaser_faces %>%
  add_count(gender) %>%
  group_by(gender, n) %>%
  summarise_at(vars(age, angry:surprised), lst(mean))
