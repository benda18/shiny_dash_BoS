library(dplyr)
library(readr)

# RESOURCES----
# crosswalks: https://github.com/timbender-ncceh/PIT_HIC/tree/main/crosswalks

# Set WD----
setwd(wd_csv)

# Load Data----
co_reg_cw        <- read_csv("https://raw.githubusercontent.com/timbender-ncceh/PIT_HIC/main/crosswalks/county_district_region_crosswalk.csv")
client           <- read_csv(NA)
enrollmentcoc    <- read_csv(NA)
enrollment       <- read_csv(NA)
projectcoc       <- read_csv(NA)
project          <- read_csv(NA)
inventory        <- read_csv(NA)
export           <- read_csv(NA)
LB_enrollmentcoc <- read_csv(NA)
LB_enrollment    <- read_csv(NA)
LB_projectcoc    <- read_csv(NA)
LB_project       <- read_csv(NA)
