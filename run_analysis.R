library(data.table)
library(dplyr)

#Download the data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
handle <- download.file(url, destfile = "data.zip")

#Unzip the downloaded file
unzip("data.zip")

#File path
path <- file.path(".", "UCI HAR Dataset")

#Load the data
#training
train_X <- read.table(file.path(path, "train", "X_train.txt"))
train_y <- read.table(file.path(path, "train", "y_train.txt"))
train_subject <- read.table(file.path(path, "train", "subject_train.txt"))

#testing
test_X <- read.table(file.path(path, "test", "X_test.txt"))
test_y <- read.table(file.path(path, "test", "y_test.txt"))
test_subject <- read.table(file.path(path, "test", "subject_test.txt"))

#rest of the data
labels <- read.table(file.path(path, "activity_labels.txt"))
features <- read.table(file.path(path, "features.txt"))

#Properly naming the columns
names(test_X) <- features[,2]
names(test_y) <- "ActivityID"
names(test_subject) <- "SubjectID"

names(train_X) <- features[,2]
names(train_y) <- "ActivityID"
names(train_subject) <- "SubjectID"

names(labels) <- c("ActivityID", "Activity")

#Merging the data
test_data <- cbind(test_subject, test_y, test_X)
train_data <- cbind(train_subject, train_y, train_X)
data <- rbind(train_data, test_data)

#Selecting the appropriate measurements
#the data has multiple columns with the same names, and because
#of this, dplyr wouldn't work properly, so we get rid of the
#repeated columns
frequencies <- as.data.frame(table(names(data)))$Freq
data <- data[,frequencies <= 1]

#Selecting only the columns that contain "mean" and "std"
new_data <- data %>% select(SubjectID, ActivityID, matches("mean|std"))

#Creating a character vector of names '"Average" + measurement name'
names <- sapply(names(new_data[3:50]),
                function(x)paste("Average", x), USE.NAMES = FALSE)

#Calculating the average for each column, grouped by subject and activity
tidy_data <- new_data %>% group_by(SubjectID, ActivityID) %>%
        summarise_at(3:50, mean)

#Assigning proper column names
colnames(tidy_data)[3:50] <- names

#Saving the data as .txt and .csv
write.table(tidy_data, "Tidy Data.txt")
write.csv(tidy_data, "Tidy Data.csv", row.names = FALSE)



