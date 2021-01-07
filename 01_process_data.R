# Source of records: https://www.govinfo.gov/app/details/GPO-PLUMBOOK-2020

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

glimpse(plum_combined)

#some column format standardization
plum_combined <- plum_combined %>% 
  mutate(
    agcy_name = str_trim(str_to_upper(agcy_name)),
    org_name = str_trim(str_to_upper(org_name)),
    org_name_level = as.character(org_name_level)
  ) 

#add column to translate appointment type acronym
plum_combined <- plum_combined %>% 
  mutate(
    type_of_appt_full = case_when(
      type_of_appt == "PAS" ~ "Presidential Appointment with Senate Confirmation",
      type_of_appt == "PA" ~ "Presidential Appointment (without Senate Confirmation)",
      type_of_appt == "CA" ~ "Career Appointment",
      type_of_appt == "NA" ~ "Noncareer Appointment",
      type_of_appt == "EA" ~ "Limited Emergency Appointment",
      type_of_appt == "TA" ~ "Limited Term Appointment",
      type_of_appt == "SC" ~ "Schedule C Excepted Appointment",
      type_of_appt == "XS" ~ "Appointment Excepted by Statute",
      TRUE ~ "none included"
    )
  ) 


#add column to translate pay type acronym
plum_combined <- plum_combined %>% 
  mutate(
    pay_plan_full = case_when(
      pay_plan == "AD" ~ "Administratively Determined Rates",
      pay_plan  == "ES" ~ "Senior Executive Service",
      pay_plan  == "EX" ~ "Executive Schedule",
      pay_plan  == "FA" ~ "Foreign Service Chiefs of Mission",
      pay_plan  == "FE" ~ "Senior Foreign Service",
      pay_plan  == "FP" ~ "Foreign Service Specialist",
      pay_plan  == "GS" ~ "General Schedule",
      pay_plan  == "PD" ~ "Daily Pay Rate* (per diem)",
      pay_plan  == "SL" ~ "Senior Level",
      pay_plan  == "TM" ~ "Federal Housing Finance Board Merit Pay",
      pay_plan  == "VH" ~ "Farm Credit Administration Pay Plan",
      pay_plan  == "WC" ~ "Without Compensation*",
      pay_plan  == "OT" ~ "Other Pay Plan* (all those not listed separately)",
      TRUE ~ "none included"
    )
  ) 

#place new columns next to their acronym columns
plum_combined <- plum_combined %>% 
  select(agcy_name:type_of_appt,
         type_of_appt_full,
         pay_plan,
         pay_plan_full,
         everything())


#save results
saveRDS(plum_combined, "processed_data/plum_combined.rds")
write_csv(plum_combined, "processed_data/plum_combined.csv", na = "")


