
setwd("~/Documents/R/data/wk4")

url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(url, 'project_files.zip')


zipF<-file.choose()
outDir<-"./final_project/files"
unzip(zipF,exdir=outDir)

library(tidyr)

# (1) Merges the training and the test sets to create one data set
featurename <- read.table('./final_project/files/UCI HAR Dataset/features.txt')

X_train <- read.table('./final_project/files/UCI HAR Dataset/train/X_train.txt')
y_train <- read.table('./final_project/files/UCI HAR Dataset/train/y_train.txt')
subject_train <- read.table('./final_project/files/UCI HAR Dataset/train/subject_train.txt')
dim(X_train)
dim(y_train)
dim(subject_train)
train <- cbind(subject_train, X_train, y_train)
dim(train)

X_test <- read.table('./final_project/files/UCI HAR Dataset/test/X_test.txt')
y_test <- read.table('./final_project/files/UCI HAR Dataset/test/y_test.txt')
subject_test <- read.table('./final_project/files/UCI HAR Dataset/test/subject_test.txt')
dim(X_test)
dim(y_test)
dim(subject_test)
test <- cbind(subject_test, X_test, y_test)
dim(test)

data <- rbind(train, test)
dim(data)

# (2) Extracts only the measurements on the mean and standard deviation for each measurement
colnames(data) <- c('subject', as.character(featurename[, 2]), 'activity')
names(data)

logicalnames <- grepl('subject|activity|mean|std', colnames(data))
newdata <- data[,logicalnames]
names(newdata)

# (3) Uses descriptive activity names to name the activities in the data set
activitylabel <- read.table('./final_project/files/UCI HAR Dataset/activity_labels.txt')
newdata$activity <- factor(newdata$activity, levels = activitylabel[, 1], labels = activitylabel[, 2])

# (4) Appropriately labels the data set with descriptive variable names

# already labelled subject and activity column with descriptive variable name in part(2)

# (5) From the data set in step 4, creates a second, independent tidy data set with the 
#     average of each variable for each activity and each subject.

library(dplyr)

newdata_mean <- newdata %>%
  group_by(subject, activity) %>%
  summarise_each(funs(mean))

write.table(newdata_mean, 'tidydata.txt', row.names = FALSE, quote = FALSE)

