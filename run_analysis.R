# 1.Merges the training and the test sets to create one data set.
## First create a directory called "mydata"
library(tibble)
library(dplyr)

if(!dir.exists("./mydata")){dir.create("./mydata")}
setwd("./mydata")
## File saved to ./mydata/projectfile.zip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "./mydata/projectfile.zip", method = "curl")
## Unzip
unzip("projectfile.zip")

## read function and activities
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
## read train and test set
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
## add code data
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "code")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")
my.y <- rbind(y_test, y_train)
## add subject data
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
Subject <- rbind(subject_train, subject_test)
## Now merge
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject, Y, X)

print("1st step completed")
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## locate mean() and std()
header.mean <- grep("mean()", headername)
header.std <- grep("std()", headername)
## combine testortrain, mean(), stg()
my_extract <- select(subject, code, contains("mean"), contains("std"))
print("2nd step completed")
# 3. Uses descriptive activity names to name the activities in the data set
## replace activity label 1:6 with descriptive label names, first load activity_labels.txt
activity_labels <- read.table("./mydata/UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
my_subbed_names = gsub("(1$)", activity_labels[1,2], my_extract_names)
my_extract3 <- `names<-`(my_extract, my_subbed_names)
print("3rd step completed")

# 4. Appropriately labels the data set with descriptive variable names. 
## uniform cases
mixed_case_names <- names(my_extract3)
lowered <- tolower(mixed_case_names)
my_extract4 <- `names<-`(my_extract3, lowered)
print("4th step completed")

## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject.
cran_my_extract <- tbl_df(my_extract4)
my_anwser <- sapply(my_extract, mean)





