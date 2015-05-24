# Following script is for building tidy data from sample data set 
# of Assignment 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
##

  # Downloaded data zip file and unzip file into working directory
  zfname <- "GC_dataset.zip"
  furl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  if (!file.exists(zfname)) {
    retval <- download.file(furl, destfile = zfname, method = "auto")
  }
  # Unzip file and get Data file in working dir
  unzip(zfname)


  # 1. Merges the training and the test sets to create one data set
  # Read files and create data set tables from test directory
  
  Xtest <- read.table('UCI HAR Dataset/test/X_test.txt')
  
  Ytest <- scan('UCI HAR Dataset/test/Y_test.txt')

  subjtest <- scan('UCI HAR Dataset/test/subject_test.txt')

  ## validate data from test directory
  ## numer of line from Y_test.txt must match with lines in subject_test.txt file
  ## and also with X_test.txt
  if ( length(Ytest) != length(subjtest) || length(Ytest) != dim(Xtest)[1] ) {
    stop('in consistance data in test directory - X_test.txt , Y_test.txt , subject_test.txt ')
  }
  
  # Read files and create data set tables from test directory
  
  Xtrain <- read.table('UCI HAR Dataset/train/X_train.txt')
  
  Ytrain <- scan('UCI HAR Dataset/train/Y_train.txt')
  
  subjtrain <- scan('UCI HAR Dataset/train/subject_train.txt')
  
  ## validate data from Train directory
  ## numer of line from Y_train.txt must match with lines in subject_train.txt file
  ## and also with X_train.txt
  if ( length(Ytrain) != length(subjtrain) || length(Ytrain) != dim(Xtrain)[1] ) {
    stop('in consistance data in train directory - X_train.txt , Y_train.txt , subject_train.txt ')
  }
  
  # Read activity labels 
  actlabs <- read.table('UCI HAR Dataset/activity_labels.txt')
  names(actlabs) <- c("activity" , "activity_label")
  
  # Read features(headers) for the data set
  features <- read.table('UCI HAR Dataset/features.txt')
  
  #Appropriately labels the data set with descriptive variable names (part of step 4)
  # Set columns names - headers on data
  names(Xtest) <- features$V2
  names(Xtrain) <- features$V2
  
  #add subject and activity  to tables data set
  Xtest$subject <- subjtest
  Xtest$activity <- Ytest
  Xtrain$subject <- subjtrain
  Xtrain$activity <- Ytrain

  # rbind test and traindata - Merge data 
  ds <- rbind(Xtest, Xtrain)


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
  # build column (measures) whcih has mean or std (TRUE/FALSE)
  colMeanStd <- grepl( '(-mean\\(\\)|-std\\(\\))', features$V2 )
  # Add TRUE for subject column
  colMeanStd <- append(colMeanStd, TRUE)
  # Add TRUE for activity column
  colMeanStd <- append(colMeanStd, TRUE)
  # extract data set for TRUE measures(mean and standard deviation)
  dsMeanSTD <- ds[, colMeanStd] 



# 3.Uses descriptive activity names to name the activities in the data set
dsMeanSTD$activity_label <- factor(dsMeanSTD$activity, levels=actlabs$V1,labels=actlabs$V2)


# 4.Appropriately labels the data set with descriptive variable names
  # names assign in step 1 make it more readable 
  names(dsMeanSTD) <- gsub("^t", "Time", names(dsMeanSTD))
  names(dsMeanSTD) <- gsub("^f", "Frequency", names(dsMeanSTD))
  names(dsMeanSTD) <- gsub("-mean\\(\\)", "Mean", names(dsMeanSTD))
  names(dsMeanSTD) <- gsub("-std\\(\\)", "StdDev", names(dsMeanSTD))
  names(dsMeanSTD) <- gsub("-", "", names(dsMeanSTD))
  names(dsMeanSTD) <- gsub("BodyBody", "Body", names(dsMeanSTD))
  

# 5. From the data set in step 4, creates a second, independent tidy data set with the 
#    average of each variable for each activity and each subject.

  # Aggregates - means  per subject per activity
  tidyds <- aggregate(dsMeanSTD[, 1:66], by = list(dsMeanSTD$subject,dsMeanSTD$activity ), FUN = mean)
  # rename Group.1 to subject
  names(tidyds)[1]<- "subject"
  # rename Group.2 to activity
  names(tidyds)[2]<- "activity"
  tidyds<- merge(x=tidyds, y=actlabs , by='activity' )
  ## reorder columns 
  tidyds <- tidyds[c(1,length(names(tidyds)), (c(2:((length(names(tidyds)))-1))))]
  
write.table( tidyds, file="TidyData.txt" , row.names = FALSE )
  
###########################
### Test by reading generated tidy file TidyData.txt
#TestTidyDS <- read.table('TidyData.txt' , header = TRUE)
###########################