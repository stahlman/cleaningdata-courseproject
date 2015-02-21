# author: Jonathan Stahlman
# date: Feb 20 2015
# run_analysis.R: a script to produce a tidy data set for the Course Project of 
# the JHU Getting and Cleaning Data class

# Problem Statement:
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each 
#    measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.

#load the necessary packages
library(data.table)
library(plyr)

#Download and unpack the data
print("Finding data")
if (!file.exists('./data')) dir.create('./data');
if (!file.exists('./data/UCI\ HAR\ Dataset')){
  if (!file.exists('./data/Dataset.zip')){
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
    download.file(fileUrl,destfile='./data/Dataset.zip', method="curl");
  }
  unzip('./data/Dataset.zip',exdir='./data')
}

#get X and Y feature names
print("Loading feature names")
X_features <- read.csv("data/UCI\ HAR\ Dataset/features.txt", sep='', header=FALSE)
X_feature_names <- sub("()","",X_features$V2, fixed=TRUE)

Y_features <- read.csv("data/UCI\ HAR\ Dataset/activity_labels.txt", 
                       col.names=c("num","label"), sep='', header=FALSE)

#read in the test and train data
print("Loading data")
data_test_X  <- data.table(read.table("data/UCI\ HAR\ Dataset/test/X_test.txt",   
                         col.names=X_feature_names))
data_train_X <- data.table(read.table("data/UCI\ HAR\ Dataset/train/X_train.txt", 
                         col.names=X_feature_names))

data_test_Y  <- read.csv("data/UCI\ HAR\ Dataset/test/y_test.txt",   
                         col.names="Activity", sep=' ', header=FALSE)
data_train_Y <- read.csv("data/UCI\ HAR\ Dataset/train/y_train.txt", 
                         col.names="Activity", sep=' ', header=FALSE)

data_test_subject  <- read.csv("data/UCI\ HAR\ Dataset/test/subject_test.txt",   
                               col.names="Subject", header=FALSE)
data_train_subject <- read.csv("data/UCI\ HAR\ Dataset/train/subject_train.txt", 
                               col.names="Subject", header=FALSE)

#combine the datasets appropriately
print("Combining data")
data <- rbind(data.frame(data_test_subject,  data_test_Y,  data_test_X),
              data.frame(data_train_subject, data_train_Y, data_train_X))

#remove the data frames to free up memory
remove(data_test_subject,  data_test_Y, data_test_X,
       data_train_subject,data_train_Y,data_train_X)

print ("Reducing data")
#determine which columns have mean/std deviation measurements using name matching
meanCols <- setdiff(grep("mean|std",colnames(data)), grep("meanFreq",colnames(data)))

# Reduce data to Subject, Activity, and mean/std. deviation measurements 
data <- data[,c(1,2,meanCols)]

#Mutate Activity from integer to factor with meaningful name 
print("Tidying data")
data <- mutate(data, Activity = Y_features$label[Activity])

#Calculate the mean of all columns separately for each activity and subject
print("Calculating means")
data_means <- ddply(data,.(Subject,Activity), 
                    function(x){colMeans(x[3:dim(x)[2]])} )

#Write out tidy data set to file
print("Writing out results")
write.table(data_means, file='means.txt', row.name=FALSE)

print("Done")