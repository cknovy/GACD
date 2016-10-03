library(reshape2)

# Load activity tables
features <- read.table("../Desktop/Classes/R/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

aLabs<- read.table("../Desktop/Classes/R/UCI HAR Dataset/activity_labels.txt")
aLabs[,2] <- as.character(aLabs[,2])


# Step 2: Extracts measurements on the mean and standard deviation
feat <- grep(".*mean.*|.*std.*", features[,2])

# Step 3: Using descriptive activity names 
feat.n <- features[feat,2]
feat.n = gsub('-mean', 'Mean', feat.n)
feat.n = gsub('-std', 'Std', feat.n)
feat.n <- gsub('[-()]', '', feat.n)


train <- read.table("../Desktop/Classes/R/UCI HAR Dataset/train/X_train.txt")[feat]
act.train <- read.table("../Desktop/Classes/R/UCI HAR Dataset/train/Y_train.txt")
sub.train <- read.table("../Desktop/Classes/R/UCI HAR Dataset/train/subject_train.txt")
train <- cbind(sub.train, act.train, train)

test <- read.table("../Desktop/Classes/R/UCI HAR Dataset/test/X_test.txt")[feat]
act.test <- read.table("../Desktop/Classes/R/UCI HAR Dataset/test/Y_test.txt")
sub.test <- read.table("../Desktop/Classes/R/UCI HAR Dataset/test/subject_test.txt")
test <- cbind(sub.test, act.test, test)

# Step 4: merge datasets and add labels
all <- rbind(train, test)
colnames(all) <- c("subject", "activity", feat.n)

# turn activities & subjects into factors
all$activity <- factor(all$activity, levels = aLabs[,1], labels = aLabs[,2])
all$subject <- as.factor(all$subject)

all.m <- melt(all, id = c("subject", "activity"))
all.mean <- dcast(all.m, subject + activity ~ variable, mean)

#Step 5: Creating tidy data set
write.table(all.m, "../Desktop/Classes/R/itssotidy.txt", row.name = F)


