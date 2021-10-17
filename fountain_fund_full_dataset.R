##################################################
## Code: fountain_fund_full_dataset.R
## Project: Fountain Fund
## Description: Combine raw data sources into single dataset before building dashboard
## Date: October 13, 2021
## Author: Susannah Derr
##################################################
rm(list=ls())
setwd("/Users/susannah/Documents/projects/fountain_fund/output_data")

library(tidyverse)
library(data.table)
library(datasets)
library(zipcodeR)
data(zip_code_db) 

zipcode<-zip_code_db %>%
  rename(city=major_city,
         zip=zipcode,
         latitude=lat,
         longitude=lng) %>%
  select(state,county,city,zip,latitude,longitude)

rm(zip_code_db)

##Read in state abbr/state name
usa_geo<-as.data.frame(usa::states) %>%
  rename(state_abbr=abb,
         state=name) %>%
  select(state,state_abbr,region,division) %>%
  mutate(division=as.character(division)) %>%
  filter(state!="Puerto Rico")

##Join and only select the columns you need (State related + lat and long)
geo_data<-usa_geo %>%
  left_join(.,zipcode,by=c('state_abbr'='state')) %>%
  group_by_('state_abbr','division','county','city') %>%
  slice(which.min(as.numeric(zip)))

temp<-list.files(pattern="*.csv")
all_files<-lapply(temp, read.csv)

full_data<-all_files %>% 
  reduce(left_join, by = "State") %>%
  # select(-c(Delegation.of.authority,Imposed.by)) %>%
  rename(population=Pop,prison_rate=prisonRate,prison_pop=prisonPop) %>%
  mutate(prison_rate=prison_rate*100,
         total_prison_releases_2016=as.numeric(total_prison_releases_2016))

#Join to state data for all states which lack any partners with county/city specific data
state<-full_data %>%
  filter(County==""&City=="") %>%
  left_join(.,geo_data,by=c('State'='state')) %>%
  group_by(State) %>%
  filter(!is.na(latitude)) %>%
  slice(which.min(as.numeric(zip))) %>%
  ungroup() %>%
  select(-c(city, county))

#Join to county data for all states which lack any partners with city specific data, but do have county-specific partners
county<-full_data %>%
  filter(County!=""&City=="") %>%
  left_join(.,geo_data,by=c('State'='state','County'='county')) %>%
  group_by(State,County) %>%
  filter(!is.na(latitude)) %>%
  slice(which.min(as.numeric(zip))) %>%
  ungroup() %>%
  select(-c(city))

#Join to city data for all states which have city-specific partners
city<-full_data %>%
  filter(County==""&City!="") %>%
  left_join(.,geo_data,by=c('State'='state','City'='city')) %>%
  filter(!is.na(latitude))%>%
  group_by(State,City,organization_name) %>%
  slice(which.min(as.numeric(zip))) %>%
  ungroup () %>%
  select(-County) %>%
  rename(County=county)

full_data<-rbind(state,county,city)%>%
  select(State,County,City,latitude,longitude, #Geography Data
         organization_name,Website,service_category,Notes, #Partner Data
         prison_rate,prison_pop,population, #Prison Population
         total_prison_releases_2016,total_jail_releases_2013, #Prison/Jail Releases
         state_unemployment_rate,state_unemployment_rank) %>% #Unemployment
  rename(prison_population=prison_pop)

path_out<-'/Users/susannah/Documents/projects/fountain_fund/'
write.csv(full_data,paste0(path_out,"Fountain Fund Data.csv"),row.names=FALSE)

