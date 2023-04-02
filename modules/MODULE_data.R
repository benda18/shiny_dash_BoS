library(dplyr)
library(readr)

# RESOURCES----
# crosswalks: https://github.com/timbender-ncceh/PIT_HIC/tree/main/crosswalks

# Write current wd so you can set it back to that once this script has run
init.wd <- getwd()


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

# Return WD to wd prior to script being run----
setwd(init.wd)
