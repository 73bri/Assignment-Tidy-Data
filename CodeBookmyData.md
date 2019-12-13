---
title: "Codebook myData"
author: "Brigitte Vogelsangs"
date: "13-12-2019"
output:
  html_document: default
  pdf_document: default
---

```{r library}
library(dplyr)
```
You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3 Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The run_analysis.R script is the data preparation and tthe 5 steps to take to get to the tidy data set.

```{r filename}
filename <- "Coursera_Homework.zip"
```
I created filename Coursera_Homework

```{r download.file}
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename)
}  
```
# Checking if archieve already exists.

I downloaded the file  

```{r file.exists}
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}  
```
# Checking if folder exists

Extracted the file under the folder called 'UCI HAR Dataset'

```{r dataframes}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("num", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
}  
```
# Assigning data frames

- features <- features.txt : data.frame with 	561 obs./rows and 2 variables/columns
    The features selected for this database come from the accelerometer and gyroscope 
    3-axial raw signals tAcc-XYZ and tGyro-XYZ.
- activities <- activity_labels.txt : 6 obs./rows and  2 variables/columns
    Dataframe of the activities performed its codes/labels
- subject_test <- test/subject_test.txt : 2947 obs./rows and 1 variable/column
    contains test data of 9 volunteers out of 30 volunteers
- x_test <- test/X_test.txt : 2947 obs./rows, 561 variables/columns
    contains test data set
- y_test <- test/y_test.txt : 2947 obs./rows and 1 variable/column
    contains test data labels
- subject_train <- test/subject_train.txt : 7352 obs./rows, 1 variable/column
    contains train data of 21 volunteers out of 30 volunteers
- x_train <- test/X_train.txt : 7352 obs./rows, 561 variables/columns
    contains training data set
- y_train <- test/y_train.txt : 7352 obs./rows, 1 variable/columns
    contains training data labels

```{r merging}
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)
```

#Merges the training and the test sets to create one data set.

- X (10299 obs./rows, 561 variables/ columns) dataframe is created by merging x_train and x_test using rbind() function
- Y (10299 obs./rows, 1 variable/column) dataframe is created by merging y_train and y_test using rbind() function
- Subject (10299 obs./rows, 1 variable/column) is created by merging subject_train and subject_test using rbind() function
- Merged_Data (10299 obs./rows, 563 variables/columns) is created by merging Subject, Y and X using cbind() function

```{r selection}
Selection <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))
```

#Extracts only the measurements on the mean and standard deviation for each measurement.

Selection (10299 obs./rows, 88 variables/columns) uses the select function to subset the mean and standerd deviation measurements from the Merged_Data set by selecting columns: subject, code 

```{r names}
Selection$code <- activities[Selection$code, 2]
```

#Uses descriptive activity names to name the activities in the data set

The Selection$code function will only show the names of the activities by replacing the code column with the code name from the second column of the data set. 

```{r labels}
names(Selection)[2] = "activity"
names(Selection) <- gsub("^t", "Time", names(Selection))
names(Selection) <- gsub("^f", "Frequency", names(Selection))
names(Selection) <- gsub("tBody", "TimeBody", names(Selection))
names(Selection) <- gsub("BodyBody", "Body", names(Selection))
names(Selection) <- gsub("Acc", "Accelerometer", names(Selection))
names(Selection) <- gsub("Gyro", "Gyroscope", names(Selection))
names(Selection) <- gsub("gravity", "Gravity", names(Selection))
names(Selection) <- gsub("BodyBody", "Body", names(Selection))
names(Selection) <- gsub("Mag", "Magnitude", names(Selection))
names(Selection) <- gsub("-mean()", "Mean", names(Selection), ignore.case = TRUE)
names(Selection) <- gsub("-std()", "STD", names(Selection), ignore.case = TRUE)
names(Selection) <- gsub("-freq()", "Frequency", names(Selection), ignore.case = TRUE)
names(Selection) <- gsub("angle", "Angle", names(Selection))
```

#Appropriately labels the data set with descriptive variable names.

I changed the labels of the data set with descriptive variable names.
code column in Selection renamed into activities. 
I used gsub function to change all names by the descriptive names:

- Acc in column’s name replaced by Accelerometer
- Gyro in column’s name replaced by Gyroscope
- BodyBody in column’s name replaced by Body
- All Mag in column’s name replaced by Magnitude
- Start with character f in column’s name replaced by Frequency
- Start with character t in column’s name replaced by Time
- gravity and angle changed into capitals

```{r mean}
myData <- Selection %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(myData, "HomeworkData.txt", row.name=FALSE)
```

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
Created an independent tidy data set called myData with the mean of each variable for each activity and each subject. Uses group_by function to select activity and subject and then summerized the the data set taking the average(mean).
Used function write.table to export myData data set to a textfile called "HomeworkData.txt"
myData (180 obs./rows, 88 variables/columns).


