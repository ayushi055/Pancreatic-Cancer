#' ---
#' title: "Final Project"
#' author: "Ayushi Jain"
#' date: "2025-04-06"
#' output: html_document
#' editor_options: 
#'   chunk_output_type: console
#' ---
#' 
## ----setup, include=FALSE-------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

#' 
## -------------------------------------------------------------------------------------------------
library(readxl)
library(tidyverse)
library(MatchIt)

seer <- read_xlsx("~/Desktop/Biostat Consulting/SEER Pancreatic Cancer Survival Data.xlsx")

year <- 2016:2021
stage <- c("Localized", "Regional") #exclude "Distant" stage because surgery likely cannot be executed for very late stage cancer

# Filter by inclusion criteria and remove rows with NA values for survival months and matching variables
seer <- seer %>% 
  filter(`Year of diagnosis` %in% year, 
         `Combined Summary Stage (2004+)` %in% stage,
         `Survival months` != "Unknown", 
         !`Age recode with <1 year olds` %in% c("00 years", "01-04 years", "05-09 years", "10-14 years", "15-19 years"), 
         `Race recode (White, Black, Other)` != "Unknown",
         `Rural-Urban Continuum Code` != "Unknown/missing/no match/Not 1990-2022" ) %>% 
  mutate(Surgery = ifelse(`RX Summ--Surg Prim Site (1998+)` == 0, 0, 1), 
         Race = `Race recode (White, Black, Other)`,
         Location = `Rural-Urban Continuum Code`,
         Stage = `Combined Summary Stage (2004+)`,
         lower_age = as.numeric(str_extract(`Age recode with <1 year olds`, "\\d+")),
         Age = case_when(
           lower_age < 40 ~ "<40",
           lower_age >= 40 & lower_age < 50 ~ "40-49",
           lower_age >= 50 & lower_age < 60 ~ "50-59",
           lower_age >= 60 & lower_age < 70 ~ "60-69",
           lower_age >= 70 & lower_age < 80 ~ "70-79",
           lower_age >= 80 ~ "≥80"
           ),
         Status = ifelse(`Vital status recode (study cutoff used)`=="Alive", 0, 1)
    
  ) 


#' 
## -------------------------------------------------------------------------------------------------
# 1:1 nearest neighbor propensity score matching without replacement with propensity score estimated using logistic regression of the treatment on the covariates
matching <- matchit(Surgery ~ Age + Sex + Race + Location + Stage, caliper = 0.1, data = seer)
summary(matching)

#matched data set
matched <- match.data(matching)

#plot to visualize matching
plot(matching, type = "jitter", interactive=F)

#' 
## -------------------------------------------------------------------------------------------------

#tables with count and percentage in each group and chi-squared tests

#Age
unmatched.age <- table(seer$Surgery, seer$Age) #count
prop.table(unmatched.age, margin = 2) * 100 #percentage
chisq.test(unmatched.age, correct = F) 
matched.age <- table(matched$Surgery, matched$Age) #count
prop.table(matched.age, margin = 2) * 100 #percentage
chisq.test(matched.age, correct = F)

#Sex
unmatched.sex <- table(seer$Surgery, seer$Sex)
prop.table(unmatched.sex, margin = 2) * 100
chisq.test(unmatched.sex, correct = F)
matched.sex <- table(matched$Surgery, matched$Sex)
prop.table(matched.sex, margin = 2) * 100
chisq.test(matched.sex, correct = F)

#Race
unmatched.race <- table(seer$Surgery, seer$Race)
prop.table(unmatched.race, margin = 2) * 100
chisq.test(unmatched.race, correct = F)
matched.race <- table(matched$Surgery, matched$Race)
prop.table(matched.race, margin = 2) * 100
chisq.test(matched.race, correct = F)

#Location
unmatched.location <- table(seer$Surgery, seer$Location)
prop.table(unmatched.location, margin = 2) * 100
chisq.test(unmatched.location, correct = F)
matched.location <- table(matched$Surgery, matched$Location)
prop.table(matched.location, margin = 2) * 100
chisq.test(matched.location , correct = F)

#Stage
unmatched.stage <- table(seer$Surgery, seer$Stage)
prop.table(unmatched.stage, margin = 2) * 100
chisq.test(unmatched.stage, correct = F)
matched.stage <- table(matched$Surgery, matched$Stage)
prop.table(matched.stage, margin = 2) * 100
chisq.test(matched.stage, correct = F)

#' 
## -------------------------------------------------------------------------------------------------
#KM Curves
library(survival)

matched$`Survival months` <- as.numeric(matched$`Survival months`)
KM <- survfit(Surv(time = `Survival months`, event = `Status`) ~ Surgery, data = matched)
plot(KM,
     col = c("blue", "red"),
     xlab = "Time (months)",
     ylab = "Survival Probability",
     main = "Kaplan-Meier Curves by Treatment Group")

# Add a legend
legend("topright",
       legend = c("No Surgery", "Surgery"),
       lty=1,
       col = c("blue", "red"),
       bty = "n")

logrank <- survdiff(Surv(time = `Survival months`, event = `Status`) ~ Surgery, data = matched)

#' 
## -------------------------------------------------------------------------------------------------
#95% CI (log-log)
KM <- survfit(Surv(time = `Survival months`, event = `Status`) ~ Surgery, data = matched, conf.type = "log-log")
# Plot with gray solid confidence intervals
plot(KM, 
     col = c("blue", "red"),           
     conf.int = T,                  
     xlab = "Survival Time (Months)", 
     ylab = "Survival Probability",
     main = "Kaplan-Meier Curves by Treatment Group",
     mark.time = FALSE)

legend("topright", 
       legend = c("No Surgery", "95% CI", "Surgery", "95% CI"), 
       col = c("blue", "blue", "red", "red"), 
       lty = c(1, 2, 1, 2),
       bty = "n")


logrank <- survdiff(Surv(time = `Survival months`, event = `Status`) ~ Surgery, data = matched)

#' 
## -------------------------------------------------------------------------------------------------
seer$`Survival months` <- as.numeric(seer$`Survival months`)

KM_unmatched <- survfit(Surv(time = `Survival months`, event = `Status`) ~ Surgery, data = seer)
plot(KM_unmatched,
     col = c("blue", "red"),
     xlab = "Time (months)",
     ylab = "Survival Probability",
     main = "Kaplan-Meier Curves by Treatment \n on Unmatched Data")

# Add a legend
legend("topright",
       legend = c("No Surgery", "Surgery"),
       lty=1,
       col = c("blue", "red"),
       bty = "n")


#' 
## -------------------------------------------------------------------------------------------------
seer$`Tumor Size Summary (2016+)` <- as.numeric(seer$`Tumor Size Summary (2016+)`)
colnames(seer)[colnames(seer) == "Chemotherapy recode (yes, no/unk)"] <- "Chemotherapy"
cox_model <- coxph(Surv(time = `Survival months`, event = `Status`) ~ strata(Surgery) + Age + Sex + Race + Location + `Tumor Size Summary (2016+)` + Chemotherapy, data = seer)


summary(cox_model)

surv_fit <- survfit(cox_model)

plot(surv_fit, 
     col = c("blue", "red"),  
     lty = 1,              
     xlab = "Survival Time (Months)", 
     ylab = "Survival Probability",
     main = "Cox PH Model by Treatment",
     mark.time = F)        

# Add a legend to the plot
legend("bottomright", 
       legend = c("No Surgery", "Surgery"), 
       col = c("blue", "red"),         
       lty = 1,                      
       bty = "n")                      

schoenfeld <- cox.zph(cox_model)
plot(schoenfeld[1], col="green", main="Age")
abline(h = 0, col = "red", lty = 2)

plot(schoenfeld[5], col="green", main="Tumor Size", ylab = "Beta(t) for Tumor Size")
abline(h = 0, col = "red", lty = 2)

plot(schoenfeld[6], col="green", main="Chemotherapy")
abline(h = 0, col = "red", lty = 2)

#' 
#' 
## -------------------------------------------------------------------------------------------------
cox_new <- coxph(Surv(time = `Survival months`, event = `Status`) ~  strata(Surgery) + strata(Chemotherapy) + Age + Sex + Race + Location + `Tumor Size Summary (2016+)`, data = seer)


summary(cox_new)

surv_fit1 <- survfit(cox_new)

plot(surv_fit1, 
     col = c("blue", "red"),          
     conf.int = F,                                  
     lty = 1,                         
     xlab = "Survival Time (Months)", 
     ylab = "Survival Probability",
     main = "Cox PH Model Survival Curves \n by Treatment",
     mark.time = FALSE)

legend("topright", 
       legend = c("No Surgery", "Surgery"), 
       col = c("blue", "red"), 
       lty = c(1, 1),
       bty = "n")                     

#' 
## -------------------------------------------------------------------------------------------------
schoenfeld1 <- cox.zph(cox_new)

#' 
## -------------------------------------------------------------------------------------------------

KM_chemo <- survfit(Surv(time = `Survival months`, event = `Status`) ~ Chemotherapy, data = seer)
plot(KM_chemo,
     col = c("blue", "red"),
     xlab = "Time (months)",
     ylab = "Survival Probability",
     main = "Kaplan-Meier Curves by Chemotherapy Status")

# Add a legend
legend("topright",
       legend = c("No/Unknown", "Yes"),
       lty=1,
       col = c("blue", "red"),
       bty = "n")


#' 
