#download zipped data:
setwd("C:/Users/corin/Desktop/coursera/course3/week4")

dataset_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(dataset_url, "data.zip")
unzip("data.zip", exdir = "data")


#import datasets: 

X_train <- read.table("data/UCI HAR Dataset/train/X_train.txt", sep = "")
y_train <- read.table("data/UCI HAR Dataset/train/y_train.txt", sep = "")
subject_train <- read.table("data/UCI HAR Dataset/train/subject_train.txt", sep = "")

X_test <- read.table("data/UCI HAR Dataset/test/X_test.txt", sep = "")
y_test <- read.table("data/UCI HAR Dataset/test/y_test.txt", sep = "")
subject_test <- read.table("data/UCI HAR Dataset/test/subject_test.txt", sep = "")

features <- read.table("data/UCI HAR Dataset/features.txt", sep = "")
activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt", sep = "")

# add features to give the datasets variable names: 
names(X_train) <- features[,2]
names(X_test) <- features[,2]


# combine train and test data
X_data = rbind(X_train, X_test)
Y_data = rbind(y_train, y_test)


#select only variables with mean or standard deviation in the name
library(dplyr)
name_selection <- grep("mean|std", names(X_data))
X_data2 <- subset(X_data[,name_selection])

# combine activity groups (y_data)  to the dataset:
data3 <- cbind(Y_data, X_data2)

# give the activity groups the activity name by merging the dataset with actvity_labels
data4 <- merge(data3,activity_labels, by.x = "V1", by.y = "V1")

# Remove the activity group numers
data5 <- select(data4, -V1)

# group the data by activity
data_grouped <- group_by(data5, V2)

# take the mean for each variable, for all of the 6 activities
summary_activity <- summarize_all(data_grouped, funs(mean))
write.table(summary_activity, file = "summary_activity", row.name=FALSE)