#' ---
#' title: 'Age Checking'
#' author: 'E. J. Dawson'
#' purpose: Download data and output length, weight, age plots for visual inspection
#' start date: 2022-07-21
#' date modified: 2022-08-19         
#' Notes:                             
#' ---
#' 

library(RODBC)
library(tidyverse)
library(janitor)
library(cowplot)
library(here)

dir.create(here::here("plots"), showWarnings = F)

channel <- odbcConnect(dsn = "AFSC", 
                        uid = rstudioapi::showPrompt(title = "Username", 
                                                     message = "Oracle Username", default = ""), 
                        pwd = rstudioapi::askForPassword("enter password"),
                        believeNRows = FALSE)

odbcGetInfo(channel)

# https://repository.library.noaa.gov/view/noaa/31570
# Vessel = 94 (Vesteraalen)
# Vessel = 162 (AK Knight)
# Vessel = 134 (Northwest Explorer)

# https://repository.library.noaa.gov/view/noaa/31571
# species_code = 10130 (flathead sole)
# species_code = 10210 (yellowfin sole)
# species_code = 10261 (northern rock sole)
# species_code = 10110 (arrowtooth flounder)
# species_code = 21720 (Pacific cod)
# species_code = 10285 (Alaska plaice)
# species_code = 10112 (Kamchatka flounder)

cruise <- 202101
vessel <- 94
species_code <- 10210
  
spec_dat <- RODBC::sqlQuery(channel, paste0("select * from racebase.specimen
                                where vessel = ", vessel, "and cruise = ", cruise, "and species_code =", species_code)) %>% 
  as_tibble() %>% 
  janitor::clean_names()

# plot: length at age
p1 <- spec_dat %>% 
  ggplot()+
  geom_point(aes(x = age, y = length))
# plot: weight at age
p2 <- spec_dat %>% 
  ggplot()+
  geom_point(aes(x = age, y = weight))

# plot: weight at length
p3 <- spec_dat %>% 
  ggplot()+
  geom_point(aes(x = length, y = weight))

title <- ggdraw() + draw_label(paste("Cruise:" ,cruise, "Vessel:", vessel, "Species code:", species_code), 
                               fontface='bold')

p_all <- cowplot::plot_grid(title, p1, p2, p3,
                            ncol=1, rel_heights=c(0.1, 1, 1, 1))

p_all

ggsave(plot = p_all, path = here::here("plots"), 
       filename = paste0("cruise_", cruise,"_vessel_", vessel, 
                                "_speciescode_", species_code, "diag_plot.png"))

# View(spec_dat) #View all specimen data if there is an issue, to find specimen id, etc.