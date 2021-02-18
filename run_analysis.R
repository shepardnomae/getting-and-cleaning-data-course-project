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

## locate mean() and std() combinemean(), stg()
my_extract <- select(Merged_Data, subject, code, contains("mean"), contains("std"))
print("2nd step completed")
# 3. Uses descriptive activity names to name the activities in the data set
## replace activity label 1:6 with descriptive label names, first load activity_labels.txt
my_extract$code <- activities[my_extract$code, 2]
print("3rd step completed")

# 4. Appropriately labels the data set with descriptive variable names. 
## uniform cases
names(my_extract)[2] = "activity"
names(my_extract)<-gsub("Acc", "Accelerometer", names(my_extract))
names(my_extract)<-gsub("Gyro", "Gyroscope", names(my_extract))
names(my_extract)<-gsub("BodyBody", "Body", names(my_extract))
names(my_extract)<-gsub("Mag", "Magnitude", names(my_extract))
names(my_extract)<-gsub("^t", "Time", names(my_extract))
names(my_extract)<-gsub("^f", "Frequency", names(my_extract))
names(my_extract)<-gsub("tBody", "TimeBody", names(my_extract))
names(my_extract)<-gsub("-mean()", "Mean", names(my_extract), ignore.case = TRUE)
names(my_extract)<-gsub("-std()", "STD", names(my_extract), ignore.case = TRUE)
names(my_extract)<-gsub("-freq()", "Frequency", names(my_extract), ignore.case = TRUE)
names(my_extract)<-gsub("angle", "Angle", names(my_extract))
names(my_extract)<-gsub("gravity", "Gravity", names(my_extract))

mixed_case_names <- names(my_extract)
lowered <- tolower(mixed_case_names)
my_extract4 <- `names<-`(my_extract, lowered)
print("4th step completed")

## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject.
my_answer <- my_extract4 %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(my_answer, "my_answer.txt", row.name=FALSE)





