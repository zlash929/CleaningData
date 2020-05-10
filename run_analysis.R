## Coursera
## Getting & Cleaning Data Course Project
## R V.3.6.3

## Load libraries

library(dplyr)
library(tidyr)

## Load data

features <- read.table("UCI HAR Dataset/features.txt", header = F)
labels <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("index", "labels"), header = F)

train <- read.table("UCI HAR Dataset/train/X_train.txt",header = F)
trainLabels <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "index", header = F)
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subjects", header = F)
colnames(train) <- features[,2] # Appropriately labels the data set with descriptive variable names
train <- cbind(trainSubjects, trainLabels, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt",header = F)
testLabels <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "index",header = F)
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subjects", header = F)
colnames(test) <- features[,2] # Appropriately labels the data set with descriptive variable names
test <- cbind(testSubjects, testLabels, test)


## Merge and format data

merged <- rbind(train, test) # Merges the training and the test sets to create one data set
merged <- merge(merged, labels, by.x = "index", by.y="index", all = T) # Uses descriptive activity names to name the activities in the data set
mergedExtract <- cbind(merged[,c(2,length(merged))], merged[, grepl(".mean().", names(merged))],merged[, grepl(".std().", names(merged))]) # Extracts only the measurements on the mean and standard deviation for each measurement
mergedExtractTidy <- gather(mergedExtract, variable, value, 3:length(mergedExtract)) # Create independent tidy data set
mergedExtractTidy <- mergedExtractTidy %>% group_by(subjects, labels, variable) %>% mutate(mean(value)) # Calculate average of each variable for each activity
mergedExtractTidy$value <- NULL
mergedExtractTidy <- distinct(mergedExtractTidy) # Remove duplicates

write.table(as.matrix(mergedExtractTidy), "output.txt", row.name=FALSE) # Extract output
