# Install Packages

install.packages("dplyr")
install.packages("devtools")
install.packages("reshape2")
devtools::install_github("dkahle/ggmap", ref = "tidyup")
library(tidyverse)
library(ggplot2)
library("ggmap")
library("reshape2")

# Read in data
allFacilities = read.csv("Dialysis_Facility_Compare_-_Listing_by_Facility.csv", check.name=FALSE)

View(allFacilities)

# Split into relevant columns
CA_Facility = subset(allFacilities, State == "CA", select = c("State", "Facility Name", "Five Star", "City", "County", "Profit or Non-Profit", "# of Dialysis Stations", "Patient Hospitalization category text", "Patient Hospital Readmission Category", "Patient Survival Category Text", 'Number of patients included in hospitalization summary', "Number of hospitalizations included in hospital readmission summary", "Number of patients included in survival summary", "Mortality Rate (Facility)", "Readmission Rate (Facility)", 'Hospitalization Rate (Facility)', "Patient Infection category text", "Transfusion Rate (Facility)", "Fistula Rate (Facility)", "Standard Infection Ratio", "Standardized First Kidney Transplant Waitlist Ratio"))

View(CA_Facility)

# An issue with this data set is that the columns are all characters, need to change them into factors so I can split the data accordingly

class("Profit or Non-Profit")
profit_updated = as.factor("Profit or Non-Profit")
class("Profit or Non-Profit")
View(profit_updated)

str(CA_Facility) ## all columns are characters, need to be updated to factors 
CA_Facility_Factored = as.data.frame(unclass(CA_Facility))
str(CA_Facility_Factored) ## Now returns the structure of the data set to be factored, so will make splitting the data in accordance with factor levels a lot easier
class(CA_Facility_Factored$Profit.or.Non.Profit) ## Now returns as a factor

## Standard Infection Rate - Profit vs Non-Profit

split(CA_Facility_Factored$Profit.or.Non.Profit, CA_Facility_Factored$Five.Star) ## shows number of ratings in accordance with the 


# Remove "Not Available" from SIR column

CA_Facility_Factored.avail = subset(CA_Facility_Factored, Standard.Infection.Ratio != "Not Available")
View(CA_Facility_Factored.avail)

# Classify SIR as numeric

class(CA_Facility_Factored.avail$Standard.Infection.Ratio)


# Make numeric to numbers instead of characters for SIR column

CA_Facility_Factored.avail$Standard.Infection.Ratio <- as.numeric(as.character(CA_Facility_Factored.avail$Standard.Infection.Ratio))

# Plot SIR for profit vs nonprofit

graph1 <- ggplot(data = CA_Facility_Factored.avail, aes(x = Facility.Name, y = Standard.Infection.Ratio, fill=Profit.or.Non.Profit)) +
  geom_bar(position = "dodge", stat = "identity", width = 0.5) + theme(axis.text.x = element_blank(), 
  axis.text.y = element_text(angle = 0, size = 14), axis.ticks.y = element_blank(), 
  axis.title.x = element_text(margin = margin(t = -15), size = 20),
  axis.title.y = element_text(margin = margin(t = 50), vjust = 2, size = 20),
  plot.title = element_text(hjust = 0.5, size = 25),
  axis.ticks.x = element_blank(), panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
  panel.background = element_blank(), legend.position = c(0.15, 0.85), legend.title = element_text(face="bold", size = 15), 
  legend.text = element_text(size = 12)) + ylim(0,4) + labs(x = "CA Facilities", y = "Standard Infection Ratio", fill = "Clinic Status") +
  ggtitle("Standard Infection Ratio for Facilities in CA") + geom_hline(yintercept = 1, color = "blue", size=1) +
  annotate(geom = "text", x = 379, y = 1.1, label = "SIR = 1", color = "blue", size = 5)

graph1


## Statistical Calculations

# Mean SIR of Non Profit Clinics

NonProfSIR = CA_Facility_Factored.avail %>% filter(Profit.or.Non.Profit == "Non-Profit")

mean(NonProfSIR$Standard.Infection.Ratio)

# Average SIR of For Profit Clinics

ProfSIR = CA_Facility_Factored.avail %>% filter(Profit.or.Non.Profit == "Profit")

mean(ProfSIR$Standard.Infection.Ratio)


# Percentage of Profit Clinics with an SIR >1

tally(ProfSIR) # Number of Profit Clinics

# Profit Clinics with SIR >1

HighSIRP = ProfSIR %>% filter(Standard.Infection.Ratio>1)

tally(HighSIRP) / tally(ProfSIR) * 100 # Calculate percentage


# Percentage of NOn-Profit Clinics with an SIR >1

tally(NonProfSIR) # Number of Non-Profit Clinics

# Non-Profit Clinics with SIR >1

HighSIRNP = NonProfSIR %>% filter(Standard.Infection.Ratio>1)

tally(HighSIRNP) / tally(NonProfSIR) * 100 # Calculate percentage