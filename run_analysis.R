library(dplyr)

filename <- "Coursera_Homework.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(fileURL, filename)
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}

# Assigning data frames
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("num", "functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")

#Merges the training and the test sets to create one data set.
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

#Extracts only the measurements on the mean and standard deviation for each measurement.
Selection <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#Uses descriptive activity names to name the activities in the data set
Selection$code <- activities[Selection$code, 2]

#Appropriately labels the data set with descriptive variable names.
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

#From the data set in step 4, creates a second, independent tidy data set 
#with the average of each variable for each activity and each subject.
myData <- Selection %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(myData, "HomeworkData.txt", row.name=FALSE)

