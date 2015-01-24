# 1. Merges the training and the test sets to create one data set

setwd("~/R/getting-and-cleaning-data-course-project")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt", header=FALSE)
activity_labels<-read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)

x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
names(x) <- features$V2
names(subject)<-c("subject")
names(y)<- c("activity")

data_combine <- cbind(subject, y)
data <- cbind(x, data_combine)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

sub_featuresnames <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
select_names <- c(as.character(sub_featuresnames), "subject", "activity") 
data <- subset(data,select=select_names)

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
names(activity_labels) <- c("activity_id", "activity_name")
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr);
tidydataset <- aggregate(. ~subject + activity, data, mean)
tidydataset <- tidydataset[order(tidydataset$subject,tidydataset$activity),]
write.table(tidydataset, file = "tidydata.txt",row.name=FALSE)