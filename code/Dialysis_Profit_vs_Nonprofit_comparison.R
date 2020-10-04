## Need to subset the facility data by showing only CA dialysis facility centres
## 

View(DialysisFacilityCompare)

DialysisFacilityCompare$State

install.packages("dplyr")
library(tidyverse)
library(ggplot2)
install.packages("devtools")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library("ggmap")

## Want to create a subset of the dataset that only shows CA Dialysis Facility Centres, given that the dataset shows for all states
## Also, subsetting this data set with columns that are relevant, such as 
CA_Facility = subset(DialysisFacilityCompare, State == "CA", select = c("State", "Facility Name", "Five Star", "City", "County", "Profit or Non-Profit", "# of Dialysis Stations", "Percentage of Medicare patients with Hgb<10 g/dL", "Percentage of Medicare patients with Hgb>12 g/dL", "Percent of Adult HD patients with Kt/V >= 1.2", "Percentage of Adult PD PTS with Kt/V >= 1.7","Percentage of Pediatric HD patients with Kt/V >= 1.2", "Percentage of Adult patients with hypercalcemia (serum calcium greater than 10.2 mg/dL)","Percentage of Adult patients with serum phosphorus less than 3.5 mg/dL", "Percentage of Adult patients with serum phosphorus between 3.5-4.5 mg/dL", "Percentage of Adult patients with serum phosphorus between 4.6-5.5 mg/dL", "Percentage of Adult patients with serum phosphorus between 5.6-7.0 mg/dL", "Percentage of Adult patients with serum phosphorus greater than 7.0 mg/dL", "Patient Hospitalization category text", "Patient Hospital Readmission Category", "Patient Survival Category Text", 'Number of patients included in hospitalization summary', "Number of hospitalizations included in hospital readmission summary", "Number of patients included in survival summary", "Mortality Rate (Facility)", "Readmission Rate (Facility)", 'Hospitalization Rate (Facility)', "Patient Infection category text", "Transfusion Rate (Facility)", "Fistula Rate (Facility)", 'Percentage of Adult patients with long term catheter in use', "SWR category text", "PPPW category text", "Percentage of Prevalent Patients Waitlisted"))

View(CA_Facility)

## An issue with this data set is that the columns are all characters, need to change them into factors so I can split the data accordingly
class("Profit or Non-Profit")
profit_updated = as.factor("Profit or Non-Profit")
class("Profit or Non-Profit")

str(CA_Facility) ## all columns are characters, need to be updated to factors 
CA_Facility_Factored = as.data.frame(unclass(CA_Facility))
str(CA_Facility_Factored) ## Now returns the structure of the data set to be factored, so will make splitting the data in accordance with factor levels a lot easier

class(CA_Facility_Factored$Profit.or.Non.Profit) ## Now returns as a factor

## Questions I want to understand and what I'm going to do to understand them:
## 1. Quality of care (according to five star-rating) in profit and non profit: Will create a chart with fator levels of star rating 
    ## Also want to create a map to understand where these centres are specifically located
## 2. Hospitalization rates, mortality rates, re-admission rates across profits and non-profits; these factors can be indicative of the nature of the service being provided
    ## Also want to understand this in relation to quality of care based off of the five-star survey
## 3.  Comparison of # of dialysis stations within profits and non-profits 
    ##    Does # of dialysis stations within the facility impact quality of care? And does there seem to be associations/correlations in mortality rates, re-admission rates, hospitalization rates
    ##    and the percentage of patients wait-listed?

## 1. Quality of Care in relation to Profit and Non-Profit

split(CA_Facility_Factored$Profit.or.Non.Profit, CA_Facility_Factored$Five.Star) ## shows number of ratings in accordance with the 

## To remove the missing values of "Not Available":
CA_Facility_Factored.clean = subset(CA_Facility_Factored, Five.Star != "Not Available")
CA_Facility_Factored.clean ## this will now plot the data having removed the 'not available' data of the surveys to create a cleaner bar plot
Five.Star = CA_Facility_Factored.clean$Five.Star

## Creating bar plot to show the number of five star ratings in accordance with 
five_star_profit = ggplot(CA_Facility_Factored.clean, aes(x = CA_Facility_Factored.clean$Profit.or.Non.Profit)) + geom_bar(aes(fill = Five.Star)) 
## adding appropriate labels, space apart, etc.
five_star_profit + labs( x = "Non Profit or Profit Facilities", y = "Number of Facilities", title = "Number of Profit & Non-Profit Dialysis Facilities") 

## By County -> How does this relate to the median households, etc
five_star_profit + labs( x = "Non Profit or Profit Facilities", y = "Number of Facilities", title = "") + facet_wrap(CA_Facility_Factored.clean$County)
## This shows the 


## We can see that quality of care in profits tends to be mostly be 3, 4, 5 

library(ggmap)

## 2. Rates across profits and non-profits
## Need to convert the appropriate columns to numerical columns first

CA_Facility_Factored$Mortality.Rate..Facility. <- as.numeric(as.character(CA_Facility_Factored$Mortality.Rate..Facility.))
class(CA_Facility_Factored$Mortality.Rate..Facility.)
CA_Facility_Factored$Hospitalization.Rate..Facility. <- as.numeric(as.character(CA_Facility_Factored$Hospitalization.Rate..Facility.))
CA_Facility_Factored$Readmission.Rate..Facility. <- as.numeric(as.character(CA_Facility_Factored$Readmission.Rate..Facility.))
CA_Facility_Factored$County <- as.factor(as.character(CA_Facility_Factored$County))
CA_Facility_Factored$PPPW.category.text <- as.factor(as.character(CA_Facility_Factored$PPPW.category.text)) ## Do this for categories 

str(CA_Facility_Factored)
colnames(CA_Facility_Factored)

CA_Facility_Factored.clean1 = subset(CA_Facility_Factored, Patient.Hospitalization.category.text != "Not Available")
CA_Facility_Factored.clean2 = subset(CA_Facility_Factored, Patient.Hospital.Readmission.Category != "Not Available")
CA_Facility_Factored.clean3 = subset(CA_Facility_Factored, Patient.Survival.Category.Text != "Not Available")


Mortality_PNP <- ggplot(CA_Facility_Factored.clean3) +  aes(CA_Facility_Factored.clean3$Profit.or.Non.Profit, CA_Facility_Factored.clean3$Mortality.Rate..Facility.) 
Mortality_PNP
Mortality_PNP + geom_jitter(aes(colour = Five.Star)) + labs(title = "Mortality Rates across Profit & Non-Profit Clinics", x = "", y = "")

Hospitalisation_PNP <- ggplot(CA_Facility_Factored.clean1) +  aes(CA_Facility_Factored.clean1$Profit.or.Non.Profit, CA_Facility_Factored.clean1$Hospitalization.Rate..Facility.) 
Hospitalisation_PNP + geom_jitter(aes(colour = CA_Facility_Factored$Five.Star)) + labs(title = "x", x = "", y = "")
## 

Readmission_PNP <- ggplot(CA_Facility_Factored.clean2) +  aes(CA_Facility_Factored.clean2$Profit.or.Non.Profit, CA_Facility_Factored.clean2$Readmission.Rate..Facility.) 
Readmission_PNP + geom_jitter()

Readmission_PNP + geom_jitter(aes(colour = CA_Facility_Factored$Five.Star)) + labs(title = "x", x = "", y = "") ## This shows non-profits vs profits Re-admission rates, coloured by Five-Star rating to answer

## whether centres with higher ratings have lower re-admission rates 

## Does county one is confined to affect these rates (look at facet_wrap())
## Should I add in a line of best fit?

## How are these rates across Patient Category Context, being mindful of the quality of care? 
## Patient Category Context enables us to examine the 
## Readmission Rates
Readmission_PNP + geom_jitter(aes(colour = Five.Star), size = 0.25) + facet_grid(~CA_Facility_Factored.clean2$Patient.Hospital.Readmission.Category) + labs(title = "Readmission Rates across Profit & Non-Profit Clinics in relation to Performance", x = "Profit or Non Profit", y = "Readmission Rates")

## Mortality Rates
Mortality_PNP + geom_jitter(aes(colour = Five.Star), size = 0.25) + facet_grid(~CA_Facility_Factored.clean3$Patient.Survival.Category.Text) + labs(title = "Mortality Rates across Profit & Non-Profit Clinics in relation to Performance", x = "Profit or Non Profit", y = "Mortality Rates")
## Visualization shows that survival rates in lower-rated facilities in non-profits and mediocre rated profit facilities performed worse than expected with higher mortaliity rates 

## Hospitalisation Rates
Hospitalisation_PNP + geom_jitter(aes(colour = Five.Star), size = 0.25) + facet_grid(~CA_Facility_Factored.clean1$Patient.Hospitalization.category.text) + labs(title = "Hospitalisation Rates across Profit & Non-Profit Clinics in relation to Performance", x = "Profit or Non Profit", y = "Hospitalisation Rates")

CA_Facility_Factored.clean1 = subset(CA_Facility_Factored, Patient.Hospitalization.category.text != "Not Available")

## Is there a relationship in serum phosporous levels being lower in patients in profit or non-profit facilities, and in relation to five-star ratings 

sp_less <- ggplot(CA_Facility_Factored) +  aes(CA_Facility_Factored$Mortality.Rate..Facility., CA_Facility_Factored$Percentage.of.Adult.patients.with.serum.phosphorus.greater.than.7.0.mg.dL) 
sp_less + geom_jitter(aes(color = CA_Facility_Factored$Profit.or.Non.Profit)) + geom_abline()

sp <- ggplot(CA_Facility_Factored) +  aes(CA_Facility_Factored$Mortality.Rate..Facility., CA_Facility_Factored$Percentage.of.Adult.patients.with.serum.phosphorus.greater.than.7.0.mg.dL) 
sp + geom_boxplot()

## Is there a relationship between number of dialysis stations and five star rating?

dialysis_stations <- ggplot(CA_Facility_Factored) + aes(CA_Facility_Factored$X..of.Dialysis.Stations, CA_Facility_Factored$County)
dialysis_stations + geom_count(aes(color = CA_Facility_Factored$Profit.or.Non.Profit))

Profit.Or.Non.Profit = CA_Facility_Factored$Profit.or.Non.Profit

dialysis_stations1 <- ggplot(CA_Facility_Factored) + aes(CA_Facility_Factored$X..of.Dialysis.Stations, CA_Facility_Factored$Mortality.Rate..Facility.)
dialysis_stations1 + geom_count(aes(color = Profit.Or.Non.Profit)) + labs(x = "# of Dialysis Stations", y = "Mortality Rate in Facility", title = "Mortality Rate in Relation to # of Dialysis Stations Across Profits & Non-Profits")

dialysis_stations1 + geom_count(aes(color = CA_Facility_Factored$Profit.or.Non.Profit)) + labs(x = "# of Dialysis Stations", y = "Mortality Rate in Facility", title = "Mortality Rate in Relation to # of Dialysis Stations Across Profits & Non-Profits") + facet_grid(~CA_Facility_Factored$County)
