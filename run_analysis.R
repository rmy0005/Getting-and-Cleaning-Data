library(plyr)

# Assuming the data is in the current directory.
setwd("C:/Users/mreddy/UCI HAR Dataset")

# Merges the training and the test sets to create one data set
subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/x_train.txt")
y_train <- read.table("train/y_train.txt")

subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/x_test.txt")
y_test <- read.table("test/y_test.txt")

subject_data <- rbind(subject_train, subject_test)
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("features.txt")
mean_stddev <- grep("-(mean|std)\\(\\)", features[,2])
x_data <- x_data[, mean_stddev]
names(x_data) <- features[mean_stddev, 2]

# Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y_data[,1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

# creates a second, independent tidy data set with the average of each variable 
# for each activity and each subject
tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
