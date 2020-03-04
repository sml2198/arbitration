
# last edited: Feb 27, 2020
# Sarah Michael Levine
# sarah.michael.levine@gmail.com

# prepare environment
rm(list = ls())
path = "/Users/Sarah/Desktop/arbitration/"

# libraries
library(plyr)
library(readxl)
library(anytime)

# lists
months = c("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")

#######################################################################################################################

# work with latest AAA data
file.name = paste0(path, "AAA/ConsumerReport2019_Q4.xlsx")
AAA = read_excel(file.name)

## CLEAN AAA DATA
  # lowercase var names
names(AAA) = tolower(names(AAA))

# format months in date string

# FILING DATE
x = 1
AAA$test = AAA$filing_date
for (month in months) {
  AAA$test = ifelse((grepl(month, AAA$test) & x < 10), 
                           gsub(month, paste0("0", x), AAA$filing_date), AAA$test)
  AAA$test = ifelse((grepl(month, AAA$test) & x >= 10), 
                           gsub(month, x, AAA$filing_date), AAA$test)
  x = (x + 1)
}
AAA$filing_date = AAA$test

# CLOSE DATE 
x = 1
AAA$test = AAA$closedate
for (month in months) {
  AAA$test = ifelse((grepl(month, AAA$test) & x < 10), 
                    gsub(month, paste0("0", x), AAA$closedate), AAA$test)
  AAA$test = ifelse((grepl(month, AAA$test) & x >= 10), 
                    gsub(month, x, AAA$closedate), AAA$test)
  x = (x + 1)
}
AAA$closedate = AAA$test

# split the date data and clean
test = AAA$test %>% separate(x, c("A", "B"))

substr(AAA$test, 2, 4)
gsub(str_extract(AAA$test, "^(?=\\d\\d)-"), "--", AAA$test)
stri_extract(AAA$test, regex="(?=[0-9][0-9])-")

# count missing data
sum(is.na(AAA$test))

#######################################################################################################################

# work with JAMS data
file.name = paste0(path, "JAMS/jams-consumer-case-information.xlsx")
JAMS = read_excel(file.name, sheet = "JAMS")

## CLEAN JAMS DATA
  # remove 8 empty rows
completerecords = JAMS[!is.na(JAMS$REFNO),]
names(JAMS) = tolower(names(JAMS))

#######################################################################################################################

# # create lists to loop through
# years = c("2017", "2018", "2019")
# file.list = ""
# data.list = ""
# arbitrators = c("AAA")
# 
# # loop through years and quarters to create file name 
# for (year in years) {
#   for (x in 1:4) {
#       for (arbitrator in arbitrators) {
#         
#         # make list of file names and import 
#         file.name = paste0(path, arbitrator, "/ConsumerReport", year, "_Q", x, ".xlsx")
#         file.list = c(file.list, file.name)
#         data = read_excel(file.name)
#         
#         # clean up and create columns for arbitrator, year quarter
#         data$arbitrator = arbitrator
#         data$year = year
#         data$quarter = x
#         
#         # rename dataset
#         assign(paste0(arbitrator, "_", year, "_Q", x), data)
#         data.name = paste0(arbitrator, "_", year, "_Q", x)
#         data.list = c(data.list, data.name)
#         
#       }
#   }
# }
# # remove first instance (empty)
# file.list = file.list[-c(1)]
# data.list = data.list[-c(1)]
# 
# # change one naming inconsistency in most request quarter of AAA data 
# names(AAA_2019_Q4)[names(AAA_2019_Q4)=="OTHERRELIEFREQUESTED_BUSINESS"] = "OTHERRELIEF_BUSINESS"
# names(AAA_2019_Q4)[names(AAA_2019_Q4)=="OTHERRELIEFREQUESTED_CONSUMER"] = "OTHERRELIEF_CONSUMER"
# 
# # append all data
# data.2017 = rbind(AAA_2017_Q1, AAA_2017_Q2, AAA_2017_Q3, AAA_2017_Q4)
# data.2018 = rbind(AAA_2018_Q1, AAA_2018_Q2, AAA_2018_Q3, AAA_2018_Q4)
# data.2019 = rbind(AAA_2019_Q1, AAA_2019_Q2, AAA_2019_Q3, AAA_2019_Q4) 
# data = rbind(data.2017, data.2018, data.2019)

#######################################################################################################################

