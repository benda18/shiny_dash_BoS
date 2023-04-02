library(dplyr)
library(readr)

gen_error_code <- function(){
  as.character(openssl::md5(as.character(sample(0:10324232432,size=1))))
}

# RESOURCES----
# crosswalks: https://github.com/timbender-ncceh/PIT_HIC/tree/main/crosswalks
# common HMIS functions: https://github.com/timbender-ncceh/PIT_HIC/blob/main/working_files/pit_survey_calculations.R
# chronically homeless module: https://github.com/timbender-ncceh/PIT_HIC/blob/main/working_files/pit_MODULE_chronicallyhomeless.R

# CAPTURE INITIAL STATE METADATA----

# Write current wd so you can set it back to that once this script has run
init.wd <- getwd()

# Write current vars so you don't accidentally remove any
init.vars <- c(ls(),"init.vars", "use.these")

# load common HMIS functions----
devtools::source_url(url = "https://raw.githubusercontent.com/timbender-ncceh/PIT_HIC/dev/working_files/pit_survey_calculations.R?raw=TRUE")

# get common hmis functions names
common.hmis.funs <- ls()[!ls() %in% init.vars]

# VARS----
grep("type", common.hmis.funs, ignore.case = T, value = T)

keep.these.common.funs <- c("fun_gender", 
                            "fun_race",
                            "calc_age", 
                            "hud_age_category", 
                            "get.calc_location_county", 
                            "get.proj_county", 
                            "get.calc_region", 
                            "get_coc_region", 
                            "fun_rel2hoh", 
                            "fun_1.8_def", 
                            "fun_ethnicity_def", 
                            "fun_livingsituation_def", 
                            "fun_projtype")

# Remove un-needed functions to save memory----
rm.hmis.funs <- common.hmis.funs[!common.hmis.funs %in% keep.these.common.funs]
rm(list = rm.hmis.funs)

gc()

# LOAD DATA----
# load crosswalks----
co_reg_cw        <- read_csv("https://raw.githubusercontent.com/timbender-ncceh/PIT_HIC/main/crosswalks/county_district_region_crosswalk.csv")

# load regular csv----
setwd(wd_csv)
client           <- read_csv("Client.csv")
enrollmentcoc    <- read_csv("EnrollmentCoC.csv")
enrollment       <- read_csv("Enrollment.csv")
projectcoc       <- read_csv("ProjectCoC.csv")
project          <- read_csv("Project.csv")
inventory        <- read_csv("Inventory.csv")
export           <- read_csv("Export.csv")

# load lookback csv----
setwd(wd_lb)
LB_enrollmentcoc <- read_csv("EnrollmentCoC.csv")
LB_enrollment    <- read_csv("Enrollment.csv")
LB_projectcoc    <- read_csv("ProjectCoC.csv")
LB_project       <- read_csv("Project.csv")

# TEMP: BUILD SMALL DATASET----

# find a dozen households of various makeups
all_hoh_hhid <- unique(enrollment$HouseholdID[enrollment$RelationshipToHoH == 1])

about_hhids <- data.frame(HouseholdID = all_hoh_hhid) %>% 
  as_tibble() %>%
  left_join(.,
            enrollment[enrollment$RelationshipToHoH == 1,
                       c("HouseholdID", "PersonalID", "EnrollmentID")])
colnames(about_hhids)[colnames(about_hhids) %in% "PersonalID"] <- "HoH_PersonalID"
colnames(about_hhids)[colnames(about_hhids) %in% "EnrollmentID"] <- "HoH_EnrollmentID"

about_hhids <- left_join(about_hhids, 
                         summarise(group_by(enrollment, HouseholdID),
                                   hh_size = n_distinct(PersonalID)))

# hoh race, ethnicity, gender----
hoh_race.eth.gender <- client[,c("PersonalID",
                                 "RaceNone", 
                                 "AmIndAKNative",
                                 "Asian",
                                 "BlackAfAmerican", 
                                 "NativeHIPacific", 
                                 "White", 
                                 "Ethnicity", 
                                 "Male", 
                                 "Female", 
                                 "NoSingleGender", 
                                 "Questioning", 
                                 "Transgender", 
                                 "GenderNone")]

hoh_race.eth.gender$calc_race      <- NA
hoh_race.eth.gender$calc_ethnicity <- NA
hoh_race.eth.gender$calc_gender    <- NA

for(i in 1:nrow(hoh_race.eth.gender)){
  # race
  temp <- fun_race(racenone = hoh_race.eth.gender$RaceNone[i], 
                   amindaknative = hoh_race.eth.gender$AmIndAKNative[i], 
                   asian = hoh_race.eth.gender$Asian[i], 
                   blackafamerican = hoh_race.eth.gender$BlackAfAmerican[i], 
                   nativehipacific = hoh_race.eth.gender$NativeHIPacific[i], 
                   white = hoh_race.eth.gender$White[i])
  if(length(temp) == 0){
    temp <- "<error code 9d415a763277029bcf1b3b542634a186>"
  }
  hoh_race.eth.gender$calc_race[i] <- temp
  rm(temp)
  
  # ethnicity
  temp <- fun_ethnicity_def(hoh_race.eth.gender$Ethnicity[i])
  if(length(temp) == 0){
    temp <- "<error code 2d33bb9a6fb916ecaca0cc974285952d>"
  }
  hoh_race.eth.gender$calc_ethnicity[i] <- temp
  rm(temp)
  
  # gender
  temp <- fun_gender(male        = hoh_race.eth.gender$Male[i], 
                     female      = hoh_race.eth.gender$Female[i], 
                     nosingle    = hoh_race.eth.gender$NoSingleGender[i], 
                     questioning = hoh_race.eth.gender$Questioning[i], 
                     trans       = hoh_race.eth.gender$Transgender[i], 
                     gendernone  = hoh_race.eth.gender$GenderNone[i])
  if(length(temp) == 0){
    temp <- "<error code d7e446d03d24ca8c3c09e2e5f09e457e>"
  }
  hoh_race.eth.gender$calc_gender[i] <- temp
  rm(temp)
}

hoh_race.eth.gender <- hoh_race.eth.gender[,c("PersonalID", 
                                              "calc_race", "calc_ethnicity", 
                                              "calc_gender")]

client <- full_join(x = client, 
                    y = hoh_race.eth.gender) %>%
  mutate(., 
         calc_age         = unlist(lapply(X = DOB, FUN = calc_age, age_on_date = Sys.Date())),
         calc_hud_age_cat = unlist(lapply(X = calc_age, FUN = hud_age_category)), 
         calc_vet_status  = unlist(lapply(X = VeteranStatus, FUN = fun_1.8_def))) %>%
  .[colnames(.) %in% 
      c("PersonalID", 
        "VeteranStatus", "DateCreated", "DateUpdated", "DateDeleted", 
        "ExportID", 
        "calc_race", "calc_ethnicity", "calc_gender", 
        "calc_age", "calc_hud_age_cat", 
        "calc_vet_status")]

# update about_hhids
about_hhids
client
# remove joined data and other data not needed
rm(hoh_race.eth.gender)

# END OF SCRIPT----
# Return WD to wd prior to script being run----
setwd(init.wd)

# remove vars as needed
rm(init.vars, init.wd)
