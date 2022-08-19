#' ---
#' title: 'Age Checking'
#' author: 'E. J. Dawson'
#' purpose: Download data and output length, weight, age plots for visual inspection
#' start date: 2022-07-21
#' date modified: 2022-08-19         
#' Notes:                             
#' ---
#' 


channel <- odbcConnect(dsn = "AFSC", 
                        uid = rstudioapi::showPrompt(title = "Username", 
                                                     message = "Oracle Username", default = ""), 
                        pwd = rstudioapi::askForPassword("enter password"),
                        believeNRows = FALSE)

odbcGetInfo(channel)

# https://repository.library.noaa.gov/view/noaa/31570
# Vessel = 94 (Vesteraalen)
# Vessel = 162 (AK Knight)

# https://repository.library.noaa.gov/view/noaa/31571
# species_code = 10130 (flathead sole)
# species_code = 10210 (yellowfin sole)
# species_code = 10261 (northern rock sole)
# species_code = 10110 (arrowtooth flounder)
# species_code = 21720 (Pacific cod)
# species_code = 10285 (Alaska plaice)
# species_code = 10112 (Kamchatka flounder)

  
RODBC::sqlQuery(channel, "select * from racebase.specimen
                                where vessel = 94 and cruise = 202101 and species_code = 10130")


#TOLDEO, broken from here out I think
                                  write.csv(x=a, 
                                            paste0("./data/oracle/",
                                                   tolower(strsplit(x = locations[i], 
                                                                    split = ".", 
                                                                    fixed = TRUE)[[1]][2]),
                                                   ".csv"))
  locations<-c(
    "RACEBASE.SPECIMEN")


plot(x=age, y=length, type="p")
plot(x=age, y=weight, type="p")
plot(x=weight, y=length, type="p")