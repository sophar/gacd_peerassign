run_analysis <- function() {
      #load packages
      library(dplyr)
      library(reshape2)
      
      #set wd to directory which contains data folder ("UCI HAR Dataset")
      setwd("~/Dropbox/_Coursera/Getting and cleaning Data/PeerAssignment")
      
      #load TEST subject ids, activity codes and data and combine them (cbind)
      testSubj <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "", stringsAsFactors = FALSE)
      testActi <- read.table("./UCI HAR Dataset/test/Y_test.txt", sep = "", stringsAsFactors = FALSE)
      testData <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", stringsAsFactors = FALSE)
      testData <- cbind(testSubj,testActi,testData)

      #load TRAINING subject ids, activity codes and data and combine them (cbind)
      trainSubj <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "", stringsAsFactors = FALSE)
      trainActi <- read.table("./UCI HAR Dataset/train/Y_train.txt", sep = "", stringsAsFactors = FALSE)
      trainData <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", stringsAsFactors = FALSE)
      trainData <- cbind(trainSubj,trainActi,trainData)
            
      #merge training and test data sets into one data set and name first two columns
      totData <- rbind(trainData,testData)
      colnames(totData)[1] <- "subjID"
      colnames(totData)[2] <- "activity"
      
      #read in features (features.txt) that will become variable names
      #and name rest of columns with these variable names
      varNames <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
      colnames(totData)[3:563] <- make.names(varNames[,2], unique = TRUE)
      
      #read in activity names from activity_labels.txt and replace activity codes with these names
      actiNames <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE)
      for (i in 1:6) totData[totData[,2]==i,2] <- actiNames[i,2]
      
      #keep only columns subjID, activity and the columns containing "mean..." or "std..."
      #(comment: e.g. "mean..." comes from converting "mean.()" using make.names before) 
      totData <- select(totData,subjID,activity, contains('mean...'), contains('std...'))
      colnames(totData) <- gsub("...",".",colnames(totData), fixed = TRUE) #remove extra dots from column names
      
      #convert wide into long data frame by 1. selecting both mean and std columns into seperate data frames
      #2. reshaping them into a long data frame and 3. combining them again using cbind
      meanData <- select(totData,subjID,activity,tBodyAcc.mean.X:fBodyGyro.mean.Z)
      meanData <- melt(meanData, id.vars = c("subjID", "activity"), variable.name = "feature", value.name = "mean")
      meanData$feature <- gsub("mean.","",meanData$feature)
      stdData <- select(totData,subjID,activity,tBodyAcc.std.X:fBodyGyro.std.Z)
      stdData <- melt(stdData, id.vars = c("subjID", "activity"), variable.name = "feature", value.name = "std")
      stdData$feature <- gsub("std.","",stdData$feature)
      colcheck <- identical(meanData[,1:3],stdData[,1:3]) #can be removed, was a double check for reshape process
      longData <- cbind(meanData,stdData[,4])
      colnames(longData)[5] <- "std"    #adding a column name that got lost
      
      
      # Step 5: Create seperate data set with mean over variable, activity, subject
      # First group the file by the three factors, then calculate mean for columns mean and std
      splitLong <- group_by(longData, subjID, activity, feature)
      output5 <- summarize(splitLong, mMean = mean(mean, na.rm = TRUE),
                mStd = mean(std, na.rm = TRUE))
      write.table(output5,file = "tidy.txt", row.name = FALSE)
      
}