library(tidyverse)
library(rvest)

rvest::read_html("https://en.wikipedia.org/wiki/AFI%27s_100_Years...100_Movies_(10th_Anniversary_Edition)")

afi_list = rvest::read_html("https://en.wikipedia.org/wiki/AFI%27s_100_Years...100_Movies_(10th_Anniversary_Edition)") %>%
  html_table()

top100 = afi_list[[2]]

top100 %>%
  count(Director, sort = T)

# Scraping 2

lemonde = rvest::read_html("https://www.lemonde.fr/")

articles = lemonde %>%
  html_elements("div.article")

paywalled = lemonde %>%
  html_elements("div.article span.sr-only")

paywall_share = length(paywalled)/length(articles)
paywall_share
