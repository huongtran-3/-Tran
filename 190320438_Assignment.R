# **************************************************************#
# CDT Social Analytics and Visualisation (SMI610) - June 2020
# ***** Assignment     
# Machine Learning and Cluster Analysis of Rent Pricing in Brazil
# **************************************************************#
# Student ID: 190320438
# **************************************************************#
# Part 1: Exploring data
# **************************************************************#

library(tidyverse)
library(ggExtra)
htr <-read.csv("Desktop/9. SMI610 Social Analytics and Visualization/FA/houses_to_rent.csv") 
htr2 <-read.csv("Desktop/9. SMI610 Social Analytics and Visualization/FA/houses_to_rent_v2.csv") 

# ----- Getting familiar with the dataset -----
# Check structure of the dataset
str(htr2)
# Look at the data
View(htr2)
head(htr2)

# Check for missing values
sapply(htr2, function(y) sum(length(which(is.na(y)))))

# tidyverse alternative
count_na <- function(x){
  sum(is.na(x))
}

htr2 %>% map_int(count_na)

# Check class of each variable
htr2 %>% map_chr(class)

# Descriptive summary
summary(htr2)

# Quick visual inspection of the data
library(GGally)

ggpairs(htr2)

cor.test(htr2$total..R.., htr2$rent.amount..R..)

# ----- Exploratory analysis with DataExplorer  -----
library(DataExplorer)

# Plot a summary of variable types etc. in graphical form
plot_intro(htr2)

# Check for missing values
plot_missing(htr2, ggtheme = theme_minimal(base_size = 10))

# Check for correlations
plot_correlation(htr2, type = 'all', cor_args = list(method = "spearman", 
                                                        use = "pairwise.complete.obs"), ggtheme = theme_minimal(base_size = 6), na.omit(TRUE))

#plot numeric variables as density plot
plot_density(htr2, ggtheme = theme_minimal(base_size = 10))

plot_bar(htr2[,-5], ggtheme = theme_minimal(base_size = 12))

# Plot any categorical data by target variable
htr2$animal <- as.factor(htr2$animal)
plot_boxplot(htr2, by = "animal")

# tidyverse alternative to the above
htr2 %>%
  mutate(furniture = as.factor(furniture)) %>%
  plot_boxplot(by = "furniture")

#################################################################
# Plit data to training and test set
#################################################################
library(purrr)
library(caret)
library(car)
# Create the training and test sets
set.seed(100)  
data <- htr2
data.rows <- createDataPartition(data$total..R.., p=0.7, list=FALSE)
train.data <- data[data.rows, ]
test.data <- data[-data.rows, ]


# **************************************************************#
# Part 2: Regression Analysis
# **************************************************************#
library(broom)
library(dplyr)

# Train models on training data
lm.model <- lm(rent.amount..R.. ~ rooms+bathroom+parking.spaces, data = train.data)
summary(lm.model)

plot(lm.model, which=1)
glance(lm.model)

# Predictions on test data
lm.pred <- predict(rent.amount..R..~rooms+bathroom+parking.spaces, test.data)

dev.off()
layout(matrix(1:6, ncol=2, byrow=TRUE)) 
plot(lm.model, 1:6)
par(mfrow=c(1,1))

car::vif(lm.model)
# **************************************************************#
# Part 3: Machine Learning using other algorithms
# 
# **************************************************************#
library(mlbench)
library(dplyr)
library(GGally)
library(lattice)
library(caret)
library(gbm)
# **************************************************************#
# Transform/scale the values
# **************************************************************
htr2$rent.amount..R.. <- as.numeric(htr2$rent.amount..R.. )
htr2$rooms <- as.numeric(htr2$rooms)
htr2$bathroom <- as.numeric(htr2$bathroom)
htr2$parking.spaces <- as.numeric(htr2$parking.spaces)

x <- htr2 %>% 
  dplyr::select(rent.amount..R..)
str(x)

htr2.scaled.data <- scale(htr2[3:5]) # apply scaling to numeric values only
head(htr2.scaled.data)


rent.scaled.data <- cbind(htr2.scaled.data, x)
head(rent.scaled.data)

# **************************************************************#
# Set up the data - training and test sets
# **************************************************************#
#install.packages("caret")
library(caret)
set.seed(123)

data <- rent.scaled.data$rent.amount..R.. %>%
  createDataPartition(p=0.7, list=FALSE)

train.data <- rent.scaled.data[data, ]
test.data <- rent.scaled.data[-data, ]

summary(train.data)
summary(test.data)

# **************************************************************#
# Using caret to perform classification 
# **************************************************************#

# define training control
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

# Run all classifiers on the training data
set.seed(100)
set.seed(100)
lda.model <- train(rent.amount..R..~., 
                   data=train.data, method="lda", metric=metric, trControl=control)
set.seed(100)
cart.model <- train(rent.amount..R..~., data=train.data, method="rpart", metric=metric, trControl=control)
set.seed(100)
knn.model <- train(rent.amount..R..~., data=train.data, method="knn", metric=metric, trControl=control)
set.seed(100)
svm.model <- train(rent.amount..R..~., data=train.data, method="svmRadial", metric=metric, trControl=control)
set.seed(100)
rf.model <- train(rent.amount..R..~., data=train.data, method="rf", metric=metric, trControl=control)
set.seed(100)
gbm.model <- train(rent.amount..R..~., data=train.data, method="gbm", metric=metric, trControl=control)

results <- resamples(list(nb=nb.model, 
                          lda=lda.model, 
                          cart=cart.model, 
                          knn=knn.model, 
                          svm=svm.model, 
                          rf=rf.model,
                          gbm=gbm.model))

summary(results)

# generate boxplots of results
bwplot(results)

# difference in model predictions
diffs <- diff(results)

# summarize p-values for pairwise comparisons
summary(diffs)

# compare models
compare_models(knn.model, svm.model, metric="Accuracy")

# Feature analysis using featurePlot() - visually examine how the 
# predictors influence the Outcome 
# See: https://www.machinelearningplus.com/machine-learning/caret-package/

#featurePlot(x = train.data[, 1:8], 
#            y = train.data$diabetes, 
#            plot = "box", # change to density
#            strip=strip.custom(par.strip.text=list(cex=.7)),
#            scales = list(x = list(relation="free"), 
#                          y = list(relation="free")))

# Make predictions, e.g. with knn
svm.predictions <- predict(svm.model, test.data)
confusionMatrix(svm.predictions, test.data$diabetes, positive = "pos")




# **************************************************************#
# Decision trees
# **************************************************************#

# define training control
control <- trainControl(method="cv", number=10)
metric <- "Accuracy"

library(itertools)
library(iterators)
library(klaR)
library(missForest)
library(rpart)

# Do this to allow for reproducibility
set.seed(123)

# Build the decision tree
rpart.model <- rpart(rent.amount..R..~rooms+bathroom+parking.spaces, 
                     data=train.data, method="class")

# Plot the decision tree
par(xpd=NA)
plot(rpart.model, main="Decision Trees for rent amount (training data)")
text(rpart.model, digits=2, cex=0.6)

# Another way of plotting the model
print(rpart.model, digits=2)

# Plot a fancier decision tree using rattle
library(rattle)
library(randomForest)

par(xpd=NA)
fancyRpartPlot(rpart.model, sub = NULL, main = "Decision Tree")

# Make predictions
rpart.predictions <- rpart.model %>% predict(test.data, type="class")
mean(rpart.predictions == test.data$rent.amount..R..)

# Can also output probabilities of each case being assigned to pos and neg classes
rpart.predictions<-rpart.model %>% predict(test.data, type="class")

# **************************************************************#
# Random Forest
# **************************************************************#
library(randomForest)
library(MASS)
library(caret)

set.seed(123)

control <- trainControl(method="cv", number=10)

rf.reg.model <- train(rent.amount..R..~rooms+bathroom+parking.spaces, 
                      data=train.data, method="rf", trControl=control)

rf.reg.predictions <- predict(rf.reg.model, test.data)
head(rf.reg.predictions)

x <- cbind(test.data, rf.reg.predictions)
head(x)

RMSE(rf.reg.predictions, test.data$rent.amount..R..)

RMSE.forest <- sqrt(mean((rf.reg.predictions-test.data$rent.amount..R..)^2))
RMSE.forest

MAE.forest <- mean(abs(rf.reg.predictions-test.data$rent.amount..R..))
MAE.forest

# Fit a regression line to the actual vs. predicted points
ggplotRegression <- function (fit) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
    geom_point(alpha = 0.7) +
    geom_abline(intercept=0, slope=1) +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$coef[[2]], 5),
                       " P =",signif(summary(fit)$coef[2,4], 5))) +
    xlab("Actual") +
    ylab("Predicted")
}

results <- data.frame(actual=test.data$rent.amount..R.., rf_predictions=rf.reg.predictions)
absline <- lm(results$actual ~ results$rf_predictions, data = results)

dev.off() # may need to run this
ggplotRegression(absline)

# ----------------------------------------------------------------------
# Feature selection using RFE
# ----------------------------------------------------------------------

library(mlbench)

# define the control using a random forest selection function - takes a while
rfe.control <- rfeControl(functions=rfFuncs, method="cv", number=10)

# run the RFE algorithm
results <- rfe(train.data[, 2:10], train.data[, 10], sizes=c(2:10), 
               rfeControl=rfe.control)

# summarize the results
print(results)

# list the chosen features
predictors(results)

# plot the results
plot(results, type=c("g", "o"))

# Take top 5 predictors
predictors <- c("rent.amount..R..","rooms", "bathroom", "parking.spaces")

rf.reg.model.2 <- train(rent.amount..R..~rooms+bathroom+parking.spaces, 
                        data=train.data[,predictors], method="rf", trControl=control)

rf.reg.predictions.2 <- predict(rf.reg.model.2, test.data)
head(rf.reg.predictions.2)

RMSE(rf.reg.predictions.2, test.data$rent.amount..R..)





