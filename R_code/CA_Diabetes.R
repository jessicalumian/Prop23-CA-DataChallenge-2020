# *****************************************
# ==== CA Adults with Diabetes Per 100 ====
# *****************************************


# ==== GOAL(S) & IMPORTANT INFO ====

# - Create a data vizualization that highlights Diabetes Prevalence rates in CA
#   - Convey prevalence of diabetes as it relates to Dialysis clinics and kidney care
#   - Communicate prevalence rates according to specific strata

# 1.  This prevalence rate does not include pre-diabetes, or gestational diabetes. 
# 2.  This is based on the question: "Has a doctor, or nurse or other health professional ever told you that you have diabetes?" 
# 3.  The sample size for 2014 was 8,832. NOTE: Denominator data and weighting was taken from the California Department of Finance, not U.S. Census. 
#       - Values may therefore differ from what has been published in the national BRFSS data tables by the Centers for Disease Control and Prevention (CDC) or other federal agencies.

# Statewide data of Adults (>= 18 y.o.) with Diabetes per 100

# SOURCE OF DATASET USED: 
# https://data.ca.gov/dataset/adults-with-diabetes-per-100-lghc-indicator

# Let's Get Healthy California (LGHC): 
# https://letsgethealthy.ca.gov/goals/living-well/decreasing-diabetes-prevalence/

# CA Behavioral Risk Factor Surveillance System (BRFSS):
# https://www.csus.edu/center/public-health-survey-research/_internal/_documents/brfss_2018_codebook.pdf



# ==== DATA WRANGLING AND EXPLORATION ==== 

library(tidyverse) # For data wrangling w/ dplyr, importing data w/ readr, & viz w/ ggplot2
library(skimr) # For elegant data summary

# Import LGCH diabetes data locally; CSV file obtained from CA Open Data Portal
adults_diabetes_per_100 <- read_csv("adults-with-diabetes-per-100-lghc-indicator-23.csv")
#View(adults_diabetes_per_100) # View the imported diabetes CSV file in spreadsheet format

# Obtain dataset's structure and produce summary of data
glimpse(adults_diabetes_per_100)
skim_without_charts(adults_diabetes_per_100)
# Note: "Year" variable/column is stored as a numeric, not as a date data type



# *****************************
# ==== DATA VISUALIZATIONS ==== 
# *****************************

# ==== Diabetes Prevalence Rates in Total Population over time ==== 

# Create a dataframe containing Total Population data only
diabetes_TotPop <- adults_diabetes_per_100 %>%
   filter(Strata == "Total population", `Strata Name` == "Total population")

#glimpse(diabetes_TotPop) # Check if data filtering worked

# Create column chart of rates over time w/ ggplot2
Tot.Prev <- ggplot(data = diabetes_TotPop) +
  geom_col(mapping = aes(x = as_factor(Year), y = Percent), fill = "firebrick", color = "black")

# Add additional aesthetics layers 
# (i.e. text of data points, line for LGHC target, titles, labels, captions)
Tot.Prev <- Tot.Prev + 
  geom_text(mapping = aes(x = as_factor(Year), y = Percent, label = Percent), vjust = -0.5,
                      position = position_dodge(width = 1)) +
  geom_hline(yintercept = 7.0) + # Add line at LGHC target diabetes prevalence rate for CA adult population
  geom_label(mapping = aes(x = 3, y = 7.0, label = "LGHC Target: 7.0"), color = "black") + # Add text label to line
  theme_bw() +
  labs(x = "Year", y = "Cases per 100 adults", 
      title = "Diabetes Prevalence among total population of adults in California, 2012-2018",
      subtitle = "CA has most new cases of diabetes in the US according to Let's Get Healthy California Task Force",
      caption = "Let's Get Healthy California")

# View Diabetes Prevalence in Total Population
Tot.Prev



# ==== Diabetes Prevalence Rates by Income Strata and Year ==== 

# Create a dataframe containing only Income data
diabetes_Inc <- adults_diabetes_per_100 %>% filter(`Strata` == "Income")
#glimpse(diabetes_Inc) # Get a glimpse of dataframe's structure

# Column chart of diabetes prevalence by Income and Year using ggplot2
Inc.Prev <- ggplot(data = diabetes_Inc) +
  geom_col(mapping = aes(x = as_factor(Year), y = Percent, fill = as_factor(`Strata Name`)), 
           position = "dodge", color = "black") +
  scale_fill_brewer(palette = "Greens") + # Create consistent coloring scheme by Income Strata
  theme_bw() +
  labs(x = "Year", y = "Cases per 100 adults", 
       title = "Diabetes Prevalence among adults in California by Income, 2012-2018",
       subtitle = "Individuals with less income tend to have a greater burden of diabetes",
       caption = "Let's Get Healthy California",
       fill = "Income Range")

# View Diabetes x Income plot
Inc.Prev
# Income data shown reflects Household Income disaggregated into stratum



# ==== Diabetes Prevalence Rates by Age Group and Year ==== 

# *** NOTE ***: This graph was not included in Prop 23 Dialysis Analysis Presentation

# Create dataframe containing Age Group strata only
# diabetes_Age <- adults_diabetes_per_100 %>% filter(Strata == "Age")
# # glimpse(diabetes_Age) # Quick glimpse of dataframe structure
# 
# # Column chart of diabetes prevalence by year and age group
# Age.Prev <- ggplot(data = diabetes_Age) +
#   geom_col(mapping = aes(x = as_factor(Year), y = Percent, fill = `Strata Name`), 
#            position = "dodge", color = "black") +
#   scale_fill_brewer(palette = "Blues") + # Consistent coloring scheme of bars based on Age group
#   theme_bw() +
#   labs(x = "Year", y = "Cases per 100 adults", 
#        title = "Diabetes Prevalence among adults in California by Age Group, 2012-2018",
#        subtitle = "Rates of diabetes grow as age increases",
#        caption = "Let's Get Healthy California",
#        fill = "Age Group")
# 
# # Preview diabetes prevalence by age group
# Age.Prev



# ==== Diabetes Prevalence Rates by Race/Ethnicity and Year ==== 

# *** NOTE ***: This graph was not included in Prop 23 Dialysis Analysis Presentation

# Create a dataframe filtered by Race/Ethnicity
# diabetes_RaceEth <- adults_diabetes_per_100 %>%
#   filter(Strata == "Race-Ethnicity")
# #glimpse(diabetes_RaceEth) # preview dataframe's structure
# 
# # Column chart of diabetes prevalence by Race/Ethnicity and year using ggplot2
# ggplot(data = diabetes_RaceEth) +
#   geom_col(mapping = aes(x = as_factor(Year), y = Percent, fill = as_factor(`Strata Name`), position = "dodge")) +
#   scale_fill_brewer(palette = "Purples") + # Create consistent coloring scheme
#   theme_bw() +
#   labs(x = "Year", y = "Cases per 100 adults", 
#        title = "Diabetes Prevalence among Adults in California by Race/Ethnicity, 2012-2018",
#        #subtitle = "Rates of diabetes decline as income rises",
#        caption = "Let's Get Healthy California",
#        fill = "Race/Ethnicity")
