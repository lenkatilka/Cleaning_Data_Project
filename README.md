# Cleaning_Data_Project
-
## The code in this repository contains R script "run_analysis.R"
## The output is "UCI_HAR_Dataset_averages_tidy.txt" long narrow tidy data

## =============================================================================
## The following needs to be done PRIOR to running the script:
### - install packages "tidyr" and "dplyr"
### - set your working directory to UCI HAR Dataset
### - in R console / RStudio console type "source("run_analysis.R")"
### - submit script by typing "run_analysis()"
## =============================================================================

## =============================================================================
## The "run_analysis.R" script does the following:
### 1. loads data:
#### - loads packages "tidyr" and "dplyr" for easier manipulation and tidying data
#### - loads data for train and test sets
#### - binds together the data for train set: X_train.txt, y_train.txt, subject_train.txt
#### - binds together the data for test set: X_test.txt, y_test.txt, subject_test.txt
#### - adds a column "train_id" to train and test data to indicate 0 if data is test data and
####   1 if data is train data
### 2. clips train and test data:
#### - binds test data BELOW train data using rbind
#### - the name of clipped data set is "data"
### 3. assigns activity names
#### - loads "activity_labels.txt" and assigns the name labels to corresponding 
####   activity "id's" (numbers 1:6) in "data" dataset
### 4. assigns descriptive variable names:
#### - loads descriptive measure variable names from "features.txt"
#### - cleans descriptive measure variable names: replaces "-" and "()" by dots and 
####   corrects measure variables containing "BodyBody" to "Body"
#### - select only measure variables containing "mean" and "std"
#### - creates logic vector indicating which columns in "data" correspond to measure variables 
####   containing "mean" and "std"
#### - changes "data" dataset so that it contains only columns with subject id,
####   activity names and columns with descriptive measure variables containing "mean" and "std"
### 5. computes averages for all subjects, activities and measure variables:
#### - gathers data on measure (measure decriptive names in one column, measure values in 
####   one column) - this step causes that data output will be in LONG NARROW TIDY FORMAT
#### - groups data by subject id, activity, train_id, and measure
#### - computes averages on measure values
#### - outputs the data into "UCI_HAR_Dataset_averages_tidy.txt"
## =============================================================================
