Sys.setenv(
  AWS_ACCESS_KEY_ID = "XXXX",
  AWS_SECRET_ACCESS_KEY = "XXXX",
  AWS_REGION = "eu-west-1"
)

library(paws)
library(tidyverse)

get_faces = function(filename, raw = F){
  img = read_file_raw(filename)
  res = rekognition()$detect_faces(Image = list(Bytes = img),
                                   Attributes = list("ALL"))
  res = res$FaceDetails
  #return(res)
  if(length(res)==0) return(NULL)
  if(raw == T) return(res)
  list(
    agerange = res %>%  map("AgeRange") %>% map_dfr(as_tibble, .id = "person"),
    gender = res %>%  map("Gender") %>% map_dfr(as_tibble, .id = "person") %>% select(person, gender = Value),
    smile = res %>%  map("Smile") %>% map_dfr(as_tibble, .id = "person") %>% select(person, smile = Value),
    emo = res %>%  map_dfr(~ unnest_wider(tibble(a = .x$Emotions), a), .id = "person") %>% spread(Type, Confidence)
  ) %>%
    reduce(left_join) %>%
    bind_cols(map_dfr(res, "BoundingBox")) %>%
    set_names(tolower) %>%
    mutate(age = (low+high)/2) %>%
    select(person, gender, age, everything())
}

get_labels = function(filename, raw = F){
  img = read_file_raw(filename)
  res = rekognition()$detect_labels(Image = list(Bytes = img))
  if(length(res)==0) return(NULL)
  if(raw == T) return(res)
  res$Labels %>% map_dfr( ~ tibble(label = .x$Name, conf = .x$Confidence ))
}

get_nsfw = function(filename, raw = F){
  img = read_file_raw(filename)
  res = rekognition()$detect_moderation_labels(Image = list(Bytes = img), MinConfidence=30)
  if(length(res)==0) return(NULL)
  if(raw == T) return(res)
  res$ModerationLabels %>% map_dfr( ~ tibble(label = .x$Name, conf = .x$Confidence, parent = .x$ParentName ))
}