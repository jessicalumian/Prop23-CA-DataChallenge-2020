# ****************************************************
# ==== U.S. Chronic Disease Indicators (CDI) data ====
# ****************************************************


# Data Source: https://chronicdata.cdc.gov/Chronic-Disease-Indicators/U-S-Chronic-Disease-Indicators-CDI-/g4ie-h725
# Diabetes & CKD connection: https://www.cdc.gov/kidneydisease/prevention-risk/make-the-connection.html

library(tidyverse) # For data wrangling w/ dplyr and ggplot2 data viz
library(skimr) # For elegant data summaries
library(RSocrata) # To retrieve Socrata dataset as R object



# ==== DATA WRANGLING & EXPLORATION ====

# Import CDI data as an R data frame using Socrata method 
# CDI is comes from a Socrata Open Data API (SODA)
US_CDI <- read.socrata(url = "https://chronicdata.cdc.gov/resource/g4ie-h725.json")
# ^ This method takes time to run bc very large dataset (800K plus observations)


#View(US_CDI) # View raw CDI data in spreadsheet format
#skim_without_charts(US_CDI) # Use skim to create data summary
#glimpse(US_CDI) # Preview the object's structure
# May have to change "YearStart" and "YearEnd" variables to date data type

# Check the unique chronic disease health topic values in the dataset
#unique(US_CDI$Topic)

# Obtain California data on Diabetes, Cardiovascular, & Chronic Kidney Disease (CKD)
# Arrange data by Topic (A-Z), YearStart (descending = most recent), YearEnd (descend)
US_CDI_CA <- US_CDI %>%
  filter(LocationDesc == "California" & Topic %in% c("Diabetes", "Cardiovascular Disease",
                                                     "Chronic Kidney Disease")) %>%
  arrange(Topic, desc(YearStart), desc(YearEnd))

#View(US_CDI_CA) # View CA data in spreadsheet format
#skim_without_charts(US_CDI_CA) # Create data summary
#glimpse(US_CDI_CA) # Preview object's structure

# Check unique values of "Question" variable for Cardiovascular Disease observations
US_CDI_CA %>% filter(Topic == "Cardiovascular Disease") %>% distinct(Question)
# ^ Not much data related to hypertension / high blood pressure -> Focus on Diabetes and CKD data?

# Check unique values of "Question" variable for Diabetes observations
US_CDI_CA %>% filter(Topic == "Diabetes") %>% distinct(Question)
# ^ Diabetes Prevalence Data from CA Data Portal may suffice for Diabetes data (See CA_Diabetes.R)

# Check unique values of "Question" variable for CKD-related observations
US_CDI_CA %>% filter(Topic == "Chronic Kidney Disease") %>% distinct(Question)


# Create object containing CKD data in CA only filtered by questions of interest 
# and grab OVERALL rates only
US_CDI_CA_CKD <- US_CDI_CA %>%
  filter(Topic == "Chronic Kidney Disease" & 
           Question %in% c("Prevalence of chronic kidney disease among adults aged >= 18 years",
                           "Incidence of treated end-stage renal disease attributed to diabetes",
                           "Incidence of treated end-stage renal disease") &
           StratificationCategory1 == "Overall") %>% 
  arrange(desc(Question), DataValueType)

# View data in spreadsheet format
#View(US_CDI_CA_CKD)
#glimpse(US_CDI_CA_CKD) # Get glimpse of object's structure



# ==== CKD PREVALENCE ====

# Column chart of OVERALL adult CKD CRUDE prevalence in CA
CKD.crudeOVR <- ggplot(data = US_CDI_CA_CKD %>%
                         filter(Question == "Prevalence of chronic kidney disease among adults aged >= 18 years" &
                                  DataValueType == "Crude Prevalence")) +
  geom_col(mapping = aes(x = as_factor(YearEnd), y = DataValue), 
           fill = "dodgerblue", color = "black")

# Layer additional aesthetics onto CKD prevalence plot
CKD.crudeOVR <- CKD.crudeOVR  +
  geom_text(mapping = aes(x = as_factor(YearEnd), y = DataValue, label = DataValue), vjust = -0.5) +
  theme_bw() +
  labs(x = "Year", y = "Cases per 100 adults", 
       title = "Chronic Kidney Disease Prevalence among California adults 18 years or older, 2011-2018",
       caption = "Centers for Disease Control and Prevention,
       National Center for Chronic Disease Prevention and Health Promotion,
       Division of Population Health")
# Prevalence here is measured as %, can interpret as cases per 100

# Preview CKD column chart
CKD.crudeOVR



# ==== ESRD TREATMENT INCIDENCE ====

# ESRD = End-stage Renal Disease

# Bar chart of OVERALL ESRD treatment incidence CRUDE rates
ESRD.incid <- ggplot(data = US_CDI_CA_CKD %>% 
         filter(Question == "Incidence of treated end-stage renal disease" & 
                  DataValueType == "Number")) +
  geom_col(mapping = aes(x = as_factor(YearEnd), y = DataValue), 
           fill = "firebrick", color = "black") +
  geom_text(mapping = aes(x = as_factor(YearEnd), y = DataValue, label = DataValue), vjust = -0.5) +
  theme_bw() +
  labs(x = "Year", y = "Cases per 1,000,000", 
       title = "Overall incidence of treated end-stage renal disease in California, 2010-2015",
       #subtitle = "Data depicts crude incidence rates",
       caption = "Centers for Disease Control and Prevention,
       National Center for Chronic Disease Prevention and Health Promotion,
       Division of Population Health")

# View ESRD treament incidence plot
ESRD.incid



# ==== ESRD TREATMENT INCIDENCE ATTRIBUTED TO DIABETES ====

# Column chart of OVERALL incidence rates of treated end-stage renal disease attributed to diabetes
ESRD.diab.incid <- ggplot(data = US_CDI_CA_CKD %>%
         filter(Question == "Incidence of treated end-stage renal disease attributed to diabetes" &
                  DataValueType == "Number")) +
  geom_col(mapping = aes(x = as_factor(YearEnd), y = DataValue), 
           fill = "firebrick", color = "black") +
  geom_text(mapping = aes(x = as_factor(YearEnd), y = DataValue, label = DataValue), vjust = -0.5) +
  theme_bw() +
  labs(x = "Year", y = "Cases per 1,000,000", 
       title = "Overall incidence of treated end-stage renal disease attributed to diabetes, 2010-2015",
       #subtitle = "Data depicts crude incidence rates",
       caption = "Centers for Disease Control and Prevention,
       National Center for Chronic Disease Prevention and Health Promotion,
       Division of Population Health")

# View ESRD treatment incidence attributed to diabetes
ESRD.diab.incid
