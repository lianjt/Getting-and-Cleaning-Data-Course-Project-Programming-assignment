library(reshape2)

file_name <- "getdata_dataset.zip"
## unzip it
if (!file.exists("UCI HAR Dataset")) { 
    unzip(filename) 
}
## read data
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
labels[,2] <- as.character(labels[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

## only get the mean and std data, remove '-'
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
names <- features[featuresWanted,2]
names = gsub('-mean', 'Mean', names)
names = gsub('-std', 'Std', names)
names <- gsub('[-()]', '', names)

## load train data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]
trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

## load test data
test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

## merge
res <- rbind(train, test)
colnames(res) <- c("subject", "activity", names)

averages_data <- ddply(res, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "data.txt", row.name=FALSE)