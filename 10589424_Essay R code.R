rm(list = ls())
##############################################################################
# Module 5: Introduction to Multilevel Modelling R Practicals
#
#     P5.4: Adding Level 2 Explanatory Variables
#
#           Camille Szmaragd and George Leckie
#           Centre for Multilevel Modelling, 2011
##############################################################################
mydata <- read.table("Desktop/7. SOST70292 Multilevel Modelling /Final Coursework /coursework.txt",
                         sep=",", header = TRUE)

str(mydata)

dim(mydata)

head(mydata)

summary(mydata)

library(table1)
table1::label(mydata$region) <- "Government Office Region"
table1::label(mydata$hid) <- "Household ID"
table1::label(mydata$pid) <- "Person ID"

table1::table1(~region + hid + pid, data = mydata)

#Q1
#Show how many number there are in the dataset

sum(table(unique(mydata$region)))
sum(table(unique(mydata$hid)))
sum(table(unique(mydata$pid)))

df <- data.frame("Level number" = 3:1, "Level" = c("Region","Household","Person"),
                 "Number of unit" = c(12,4429,4655))
df

library(dplyr)
df2 <- aggregate(cons ~ region, data = mydata, sum)
df2

df3 <- aggregate(cons ~ hid + region, data = mydata, sum)
df6 <- function(df3) { df3[cons>1] <- 1; df3 }


#Q3
#P11.2 A Three-Level Model of THKS

#P11.2.1 Specifying and fitting the three-level model

#Estimate the null multilevel model with class as the level 2 variable (1|classid) and school as the level 3 variable (1|schoolid).


library(lme4)
require(stats)
require(lattice)
library(lattice)

nullmodel1 <- lmer(nhood_mistrust ~ (1|hid) + (1|region), data = mydata,
                   REML = FALSE)
?lmer
#Look at the model output

summary(nullmodel1)

#Look at y by hid using dplyr

y_byhid <- mydata %>%
  group_by(hid) %>%
  summarise(mean = mean(nhood_mistrust), n = n())

y_byhid

#Look at y by region using dplyr

y_byregion <- mydata %>%
  group_by(region) %>%
  summarise(mean = mean(nhood_mistrust), n = n())

y_byregion

#P11.1.2 Summarising the response and predictor variables

#Create a histogram of the dependent variable, postthks

table(mydata$nhood_mistrust)

hist(mydata$nhood_mistrust)


#P11.2.2 Interpretation of the model output
#Test whether a multilevel model improves the model fit by comparing with a single-level model using a likelihood ratio tests
#Estimate the single-level null model 
single_null <- lm(nhood_mistrust ~ 1, data = mydata)
summary(single_null)

#Estimate the 2-level model with region at level 2

twolevel_null1 <- lmer(nhood_mistrust ~ (1|region), data = mydata, REML = FALSE)

summary(twolevel_null1)

#Estimate the 2-level model with hid at level 2

twolevel_null2 <- lmer(nhood_mistrust ~ (1|hid), data = mydata, REML = FALSE)

summary(twolevel_null2)

#Test 3-level and 2-level models vs single-level

anova(nullmodel1, single_null)

anova(twolevel_null1, single_null)

anova(twolevel_null2, single_null)

#Test 3-level model with 2-level model with schoolid

anova(nullmodel1, twolevel_null1)

anova(nullmodel1, twolevel_null2)

#Q4
#hid-level VPC
vars_nullmodel1 <- as.data.frame(VarCorr(nullmodel1))

vars_nullmodel1

hid_VPC <- vars_nullmodel1[1,4] / (vars_nullmodel1[1,4] + vars_nullmodel1[2,4] + vars_nullmodel1[3,4])

hid_VPC

#Region-level VPC - this coincides with the school-level ICC for this model

region_VPC <- vars_nullmodel1[2,4] / (vars_nullmodel1[1,4] + vars_nullmodel1[2,4] + vars_nullmodel1[3,4])

region_VPC

#Q5

# Extending the logit model

mydata$urban0 <- mydata$urban == 0
mydata$urban1 <- mydata$urban == 1

mydata$urban0 [mydata$urban0 == "false"] <- 0
mydata$urban0 [mydata$urban0 == "true"] <- 1
mydata$urban1 [mydata$urban1 == "false"] <- 0
mydata$urban1 [mydata$urban1 == "true"] <- 1

mydata$female0 <- mydata$female == 0
mydata$female1 <- mydata$female == 1

mydata$female0 [mydata$female0 == "false"] <- 0
mydata$female0 [mydata$female0 == "true"] <- 1
mydata$female1 [mydata$female1 == "false"] <- 0
mydata$female1 [mydata$female1 == "true"] <- 1

mydata$hhtenure1 <- mydata$hhtenure == 1
mydata$hhtenure2 <- mydata$hhtenure == 2
mydata$hhtenure3 <- mydata$hhtenure == 3

mydata$hhtenure1 [mydata$hhtenure1 == "false"] <- 0
mydata$hhtenure1 [mydata$hhtenure1 == "true"] <- 1
mydata$hhtenure2 [mydata$hhtenure2 == "false"] <- 0
mydata$hhtenure2 [mydata$hhtenure2 == "true"] <- 1
mydata$hhtenure3 [mydata$hhtenure3 == "false"] <- 0
mydata$hhtenure3 [mydata$hhtenure3 == "true"] <- 1

mydata$hiqual31 <- mydata$hiqual3 == 1
mydata$hiqual32 <- mydata$hiqual3 == 2
mydata$hiqual33 <- mydata$hiqual3 == 3

mydata$hiqual31 [mydata$hiqual31 == "false"] <- 0
mydata$hiqual31 [mydata$hiqual31 == "true"] <- 1
mydata$hiqual32 [mydata$hiqual32 == "false"] <- 0
mydata$hiqual32 [mydata$hiqual32 == "true"] <- 1
mydata$hiqual33 [mydata$hiqual33 == "false"] <- 0
mydata$hiqual33 [mydata$hiqual33 == "true"] <- 1

fit1 <- lmer(nhood_mistrust ~ age + sclfsato + urban0 + urban1 + female0 + female1
                   + hhtenure1 + hhtenure2 + hhtenure3 
                   + hiqual31 + hiqual32 + hiqual33
                   + (1|hid) + (1|region), data = mydata, REML = FALSE)

summary(fit1)

predy <- fitted(fit1)

#Q6

fit2 <- lmer(nhood_mistrust ~ age + sclfsato + urban0 + urban1 + female0 + female1
             + hhtenure1 + hhtenure2 + hhtenure3 
             + hiqual31 + hiqual32 + hiqual33
             + (0 + age | hid) + (1 + age |region), data = mydata, 
             REML = FALSE)

# Testing for random slopes
anova(fit1, fit2)

# Examining intercept and slope residuals for hid and region
VarCorr(fit1)$hid
VarCorr(fit1)$region

#myrandomeff <- ranef(fit1, condVar = TRUE)
#plot(myrandomeff[[1]], xlab = "Intercept (u0j)", ylab = "Slope of age (u1j)")
#abline(h = 0, col = "red")
#abline(v = 0, col = "yellow")

#predscore <- fitted(fit)

#datapred <- cbind(predscore = predscore, cohort90 = mydata$cohort90, schoolid = mydata$schoolid)

#datapred <- data.frame(unique(datapred))

#datapred <- datapred[order(datapred$schoolid, datapred$cohort90), ]

#datapred$multiplecohorts <- rep(0, dim(datapred)[1])

#datapred$multiplecohorts[datapred$schoolid %in% 
#                           unique(datapred$schoolid[duplicated(datapred$schoolid)])] <- 1

#xyplot(predscore ~ cohort90, data = datapred[datapred$multiplecohorts == 1, ], 
#       groups = schoolid, type = c("p", "l"), col = "blue")


# P5.3.4 Between - school variance as a function of cohort

x <- c(-6:8)

y <- 42.859 - 2.048*x + 0.161*x^2

plot(x, y, type = "l", xlim = c(-6, 10))


# P5.3.5 Adding a random coefficient for gender (dichotomous x )

#(fit2a <- lmer(score ~ cohort90 + female + (1 + cohort90 | schoolid), data = mydata, REML = FALSE))

#(fit2 <- lmer(score ~ cohort90 + female + (1 + cohort90 + female | schoolid), data = mydata, REML = FALSE))

#anova(fit2, fit2a)





