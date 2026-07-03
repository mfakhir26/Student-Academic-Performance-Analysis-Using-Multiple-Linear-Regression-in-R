# first load the library (if not installed then first install the package then run this command)
library(tidyverse)

# setting the working directory
setwd("C:/Users/PMLS/Desktop/academic project R/working/Student_data_analysis")

#importing the datasets
maths = read.csv("student-mat.csv", sep = ";")
port = read.csv("student-por.csv", sep = ";")

#take look on both datasets by below command
View(maths)
View(port)

#matching columns variable
merge_vars = c("school","sex","age","address","famsize","Pstatus","Medu","Fedu",
               "Mjob","Fjob","reason","nursery","internet")

#merge the datasets
students = merge(maths, port, by = merge_vars, suffixes = c("_maths", "_port"))

#View the merged dataset in separate window
View(students)

#dimension
dim(students)
# 382 observations & 53 variables in the merged dataset.

#Data Cleaning

#data types
str(students)
# all data types are ok.

#now we will convert all of the categorical variables into factors
#since there are lot of variables so we will make a loop for it

attach(students)

for (col in names(students)) {
  if (is.character(students[[col]])) {
    students[[col]] <- factor(students[[col]])
  }
}

str(students)
# we can see that loop is executed successfully and all the character variables are
# now converted into factors.

#check missing values in the dataset
colSums(is.na(students)) #no missing values in data

#check duplicated values
sum(duplicated(students))

#summary statistics
summary(students) #provides descriptive statistics


#loop to generate frequency count for each categorical variable
for (col in names(students)) {
  if (is.factor(students[[col]])) {
    cat("\n============================\n")
    cat("Variable:", col, "\n")
    v = table(students[[col]])
    print(prop.table(v))
  }
}

#our target variable is G3 - final grade, datasets are merged so we have two 
# target variables G3_maths and G3_port so we make dependent variable by taking
# averarge of these two variables as

students$average_grade = (students$G3_maths + students$G3_port) / 2


# Now we will detect if there any outliers in numeric variables
boxplot(students$age) #there are outliers in this variable

# since there are some students whose age is above 18 years old so we will simply
# keep these outliers in the data and not replace or remove them.

# most of the variables are factors and ordinal variables

# decided to keep the outliers in the other variables so that we can significantly
## check their impact on target variable

boxplot(students$average_grade) #target variable

# the outliers are not random errors and should keep these low grade outliers because
# some students might have low grade in the final grade so that's why their average
# is low.

boxplot(students$G1_port) #seems one outlier at bottom of boxplot

#count number of outliers
outliers = boxplot.stats(students$G1_port)$out
length(outliers) # output is 1

#defined function to cap the outliers in a specific variable
## and returns the variable after changing

outlier_capping = function(x) {
  q1 <- quantile(x, 0.25, na.rm = TRUE)
  q3 <- quantile(x, 0.75, na.rm = TRUE)
  
  iqr_value <- IQR(x, na.rm = TRUE)
  
  lower <- q1 - (1.5 * iqr_value)
  upper <- q3 + (1.5 * iqr_value)
  
  x[x < lower] = lower
  x[x > upper] = upper
  
  return(x)
}

# G2_port variable
boxplot(G2_port) # there are outliers

# I have defined function above to cap the outliers but in this project and scenario
## I will not cap the outliers because they are not errors, some students would have
### low and high scores (G1, G2, G3) so it's better to keep them as they are.


# EDA (EXPLORATORY DATA ANALYSIS)

# checking distribution of response variable
hist(students$average_grade, 
     main = "Distribution of Average Grade", 
     xlab = "Average grade", 
     probability = TRUE, 
     col = "lightblue",
     border = "black")

curve(dnorm(x,
            mean = mean(students$average_grade),
            sd = sd(students$average_grade)),
      col = "red",
      lwd = 2,
      add = TRUE
      )
#Distribution of response variable is approximately normal.

# bar charts
# defining function to create bar chart for any categorical variable

bar_chart <- function(variable) {
  
  counts <- table(variable)
  
  barplot(
    counts,
    main = paste("Bar Plot of", deparse(substitute(variable))),
    xlab = deparse(substitute(variable)),
    ylab = "Frequency",
    col = "lightblue",
    border = "black"
  )
}

bar_chart(students$sex)
bar_chart(students$Fedu)
bar_chart(students$activities_maths)

# that's how we can create bar plots by using defined function.

#Correlation matrix
library(dplyr)

corr_matrix = students %>%
  select(where(is.numeric)) %>%
  cor()

corr_matrix # hard to read from such table because there are so many variables

#heatmap plot

install.packages("corrplot")
library(corrplot)
corrplot(corr_matrix) # heatmap plot

# we will drop Grade variables from the data because our response variable is
## constructed by these grade variables so using them as predictors would not be a good idea.

students = students %>%
  select(-c(G1_maths, G2_maths, G3_maths,G1_port, G2_port, G3_port))

dim(students)

# we have already converted categorical varibales into factors so we don't need
## to create dummies. R will automatically make dummy variables when added in the model.


# Full model
mdl = lm(average_grade ~ school + sex + age + address + famsize + Pstatus +
           Medu + Fedu + Mjob + Fjob + reason + nursery + internet + 
           guardian_maths + traveltime_maths + studytime_maths + 
           failures_maths + schoolsup_maths + famsup_maths + paid_maths +
           activities_maths + higher_maths + romantic_maths + famrel_maths +
           freetime_maths + goout_maths + Dalc_maths + Walc_maths + health_maths +
           absences_maths + guardian_port + traveltime_port + studytime_port +
          failures_port + schoolsup_port + famsup_port + paid_port + activities_port + 
           higher_port + romantic_port + famrel_port + freetime_port + goout_port + 
           Dalc_port + Walc_port + health_port + absences_port,
         data = students
           )

summary(mdl)

# we can see from our output that some variables have NA coefficients and this is
## because that we merged datasets and the values of variable i of maths and port
### will be same e.g. famrel_port has NA coefficient but famrel_maths have coefficient
#### the values are identical in both datasets because they describe the same student.

# we will drop these variables whose coefficient is NA.

model = lm(average_grade ~ school + sex + age + address + famsize + Pstatus +
                   Medu + Fedu + Mjob + Fjob + reason + nursery + internet + 
                   guardian_maths + traveltime_maths + studytime_maths + 
                   failures_maths + schoolsup_maths + famsup_maths + paid_maths +
                   activities_maths + higher_maths + romantic_maths + famrel_maths +
                   freetime_maths + goout_maths + Dalc_maths + Walc_maths + health_maths +
                   absences_maths + guardian_port + traveltime_port + studytime_port +
                   failures_port + schoolsup_port + famsup_port + paid_port + activities_port + 
                   higher_port + romantic_port,
                 data = students
)


summary(model) # R^2 = 37%

# most of the predictors are not statistically significant and our objective is to
## to see what factors affect the average grade siginificantly

# Backward elimination method would be suitable here to find the best fitted model

full_mdl = lm(average_grade ~ ., data = students)

backward_model = step(full_mdl, direction = "backward")

summary(backward_model)
# Backward stepwise selection method is used based on AIC criterion to select
## the final model so that's why I decided to keep non-significant vaiables
### because keeping them in the model improves the AIC overall of good fit.

# Checking the assumptions of the backward model

#multicollinearity assumption
install.packages("car")
library(car)

vif(backward_model)
# since the dataset was merged so the identical students information was in the merged
## dataset, so that's why same variables have high multicollinearity like
### travel_time_maths & travel_time_port and etc.

cor(traveltime_maths, traveltime_port) #0.98
# we merged the datasets so the same student will have the identical traveltime in 
## both datasets and that is the reason these variables are highly correlated

table(famsup_maths)
table(famsup_port) # both vaiables are very identical. same reason explained as above

table(higher_maths)
table(higher_port) # same informaation in both variables

# we have to include only those variables defined by step function &
## remove each one of pair of above variables so that multicollinearity can be
### reduced.

df = students %>%
    select(c(school, address, famsize, Medu, Mjob, traveltime_maths,
             failures_maths, famsup_maths, higher_maths, goout_maths,
             health_maths, studytime_port, schoolsup_port, romantic_port,
             absences_port, average_grade))
final_model = lm(average_grade ~ ., data = df)
summary(final_model)

#checking VIF again
vif(final_model)

# Plot of Residuals vs Fitted values
fitted_values = final_model$fitted.values
resid = final_model$residuals

plot(fitted_values, resid,
   xlab = "Fitted values",
   ylab = "Residuals",
   main = "Residuals VS Fitted values",
   pch = 10)

abline(h = 0, col = "red", lwd = 2)
# pattern is almost random and points show no pattern
## Error terms are independent of each other & this assumption isn't violated.

# Constant Variance
# since it is very clear that there is no pattern so the variance of the error
## terms is constant.

# Breusch–Pagan test
install.packages("lmtest")
library(lmtest)

bptest(final_model) # Breusch–Pagan test
# p-value > 0.05, we have strong evidence to fail to reject Ho & conclude that
## the residuals variance is constant.

# Normality assumption
qqnorm(resid)
qqline(resid, col = "red", lwd = 2)
# almost most of the reisduals fall on the line so the normality assumption isn't violated.

# save the model's output
sink("final_model_summary.txt")
summary(final_model)
sink() ## exports the output in textfile in the defined directory.

# coefficients table
install.packages("openxlsx")
library(openxlsx)

coef_table = as.data.frame(summary(final_model)$coefficients)
View(coef_table)
write.xlsx(coef_table, file = "Coefficients of final model.xlsx", rowNames = TRUE)

# ------------------------------------------------------------------------------