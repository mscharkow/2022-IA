library(tidyverse)
library(jsonlite)

jsonlite::fromJSON("https://www.breakingbadapi.com/api/")

quotes = jsonlite::fromJSON("https://breakingbadapi.com/api/quotes") %>%
  as_tibble()
quotes

write_tsv(quotes, "bb_quotes.tsv")

# Bonus
quotes %>%
  count(author, sort = T)

quotes %>%
  filter(series == "Better Call Saul")
