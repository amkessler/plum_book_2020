library(tidyverse)
library(janitor)
library(lubridate)
library(readxl)


#import raw files from GPO
GPO_6 <- read_excel("raw_data/GPO-PLUMBOOK-2020-6.xlsx") %>% 
  clean_names()

GPO_7 <- read_excel("raw_data/GPO-PLUMBOOK-2020-7.xlsx") %>% 
  clean_names()

GPO_8 <- read_excel("raw_data/GPO-PLUMBOOK-2020-8.xlsx") %>% 
  clean_names()

GPO_9 <- read_excel("raw_data/GPO-PLUMBOOK-2020-9.xlsx") %>% 
  clean_names()


#combine into one
plum_combined <- bind_rows(GPO_6, GPO_7, GPO_8, GPO_9)
