# Factors Affecting Student Academic Performance Using Multiple Linear Regression in R

## Overview

This project investigates the factors that influence students' academic performance using **Multiple Linear Regression** in **R**. The analysis is based on the **Student Performance Dataset** from the UCI Machine Learning Repository and focuses on identifying the demographic, social, family, and academic factors associated with students' final academic achievement.

The project demonstrates the complete data analysis workflow, including data preparation, exploratory data analysis (EDA), model building, regression diagnostics, and interpretation of results.

---

## Objectives

* Identify the factors affecting students' academic performance.
* Build a multiple linear regression model in R.
* Select the most appropriate model using backward elimination (AIC).
* Validate the regression assumptions.
* Interpret statistically significant predictors.
* Evaluate the predictive performance of the final model.

---

## Dataset

**Source:** Student Performance Dataset by Paulo Cortez and Alice Maria Gonçalves Silva

Repository:
https://archive.ics.uci.edu/dataset/320/student+performance

The project combines both the Mathematics and Portuguese student datasets using an inner join to analyze overall student performance.

---

## Response Variable

The response variable used in this study is:

**Average Grade**

It is calculated as the average of:

* Final Mathematics grade (G3_maths)
* Final Portuguese grade (G3_port)

---

## Data Preparation

The following preprocessing steps were performed:

* Imported Mathematics and Portuguese datasets.
* Merged both datasets using an inner join.
* Converted categorical variables into factors.
* Checked for missing values.
* Checked for duplicate observations.
* Created helper functions for categorical variable exploration.
* Excluded highly correlated grade variables (G1, G2 and G3) to avoid data leakage.

---

## Exploratory Data Analysis

The project includes:

* Descriptive statistics
* Histogram of the response variable
* Boxplots for outlier detection
* Bar plots for categorical variables
* Correlation heatmap
* Distribution analysis

Outliers were retained because they represented valid observations.

---

## Model Building

A full multiple linear regression model was initially fitted using all explanatory variables.

Backward elimination based on the Akaike Information Criterion (AIC) was then applied using R's `step()` function to obtain the final model.

```r
full_model <- lm(average_grade ~ ., data = students)

backward_model <- step(full_model, direction = "backward")
```

The final model retains some statistically non-significant predictors because they improve the overall AIC of the model.

---

## Regression Diagnostics

The assumptions of multiple linear regression were assessed.

✔ No multicollinearity (Variance Inflation Factor approximately equal to 1)

✔ Independence of residuals

✔ Homoscedasticity

* Verified using Residual vs Fitted plot
* Confirmed with the Breusch-Pagan test

✔ Normality of residuals

* Checked using QQ plot

The final regression model satisfied all major regression assumptions.

---

## Significant Predictors

The following variables were found to have statistically significant effects on average student grade (p < 0.05):

* Previous class failures
* School attended
* Intention to pursue higher education
* Going out with friends
* Current health status
* Extra educational support

### Key Findings

* Students with more previous failures tend to obtain lower average grades.
* Students planning to pursue higher education tend to achieve higher academic performance.
* More frequent social outings are associated with lower academic performance.
* Students enrolled in one school (MS) had lower predicted grades than those enrolled in GP.
* Extra educational support showed a negative association with grades, likely reflecting that academically weaker students are more likely to receive additional support.
* Better reported health status was associated with slightly lower grades; this should be interpreted as an observed association rather than a causal relationship.

---

## Model Performance

**R² = 0.3345**

Approximately **33.45%** of the variation in average student grades is explained by the predictors included in the model.

Although the explanatory power is moderate, the overall regression model is statistically significant (F-test, p < 0.05), indicating that the predictors collectively contribute to explaining student academic performance.

---

## Technologies Used

* R
* RStudio

### Main Packages

* dplyr
* car
* lmtest
* corrplot
* tidyverse


## Learning Outcomes

This project demonstrates practical experience in:

* Data cleaning and preprocessing in R
* Exploratory Data Analysis (EDA)
* Multiple Linear Regression
* Model selection using Backward Elimination
* Regression diagnostics
* Statistical interpretation
* Predictive modeling
* Reproducible data analysis

---

## References

Cortez, P., & Silva, A. M. G. (2008). *Using Data Mining to Predict Secondary School Student Performance*. Student Performance Dataset, UCI Machine Learning Repository.

https://archive.ics.uci.edu/dataset/320/student+performance
