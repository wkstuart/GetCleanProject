# run_analysis.R
# 2015-01-12
#
# the following code achieves the FIVE OBJECTIVES specified by the
# Johns Hopkins Coursera Course Getting and Cleaning Data 
# course project instructions (stated below)
#
# 1 Merge the training and the test sets to create one data set.
# 2 Extract only the measurements of mean and standard deviation for each measurement. 
# 3 Use descriptive activity names to name the activities in the data set
# 4 Appropriately label the data set with descriptive variable names. 
# 5 From the data set in step 4, create a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
#
##################################################################################
#
# OBJECTIVE 1 Merge the training and test sets to create one data set
#
# The raw data must be extracted from a downloaded zip file.
# The data is partitioned overall into a training and test data set.
# Each of the two partitions contains three files 
#   1. subject_zzz.txt contains a subject identifier for each observation
#   2. y_zzz.txt contains an activity identifier for each observation
#   3. X_zzz.txt contains 561 variables for each observation
# where zzz is either 'train' or 'test'.
#
# First, we combine the test and training datasets using the rbind function
#
subject <- rbind(subject_train, subject_test)
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
#
# And drop the partitioned data sets from the current environment
#
rm(subject_train,subject_test)
rm(X_train,X_test)
rm(y_train,y_test)
#
#
# The resulting merged sets, subject, y, and X each have 10299 observations.
#
# OBJECTIVE 1 is now only partially complete but I want to 
# attach understandable variable names to the 561 measurements in the
# X file before going further
#
##################################################################################
#
# START OF WORK TO ACHIEVE
# OBJECTIVE 4: Appropriately label the data set with descriptive variable names. 
#
# I'm going to use the feature names provided for the 561 measurement in X
# provided in the raw dataset in the file features.txt
#
# First, download the names from the file features.txt.
# Load these names into a data frame and give the columns meaningful names
#
varNames <- read.table("./data/UCI HAR Dataset/features.txt")
colnames(varNames) <- c('column.number.in.X', 'var.name')
#
# Unfortunately, there are duplicate variable names in this list. 
# We need to address that problem straight away since we want to use 
# these names to identify columns in our final table.
#
# First, identify the duplicates and add that info to a column in varNames.
#
varNames$var.name <- as.character(varNames$var.name)
varNames['duplicate'] <- duplicated(varNames$var.name)
sum(varNames$duplicate)
#
# Since the duplicates occur in patterns of 3, I presume that they should be labeled
# with an X, Y or Z. We're not going to be using these variables with duplicate names
# anyway because they are neither means nor standard deviations. We'll fix the problem
# by simply adding X, Y or Z to the duplicate names and store the improved name
# in a varNames as a column named 'cleaner.var.name'.
#
varNames['cleaner.var.name'] <- varNames$var.name
varNames[303:316,'cleaner.var.name'] <- paste(varNames[303:316,'var.name'],'-X',sep='')
varNames[317:330,'cleaner.var.name'] <- paste(varNames[317:330,'var.name'],'-Y',sep='')
varNames[331:344,'cleaner.var.name'] <- paste(varNames[331:344,'var.name'],'-Z',sep='')
varNames[382:395,'cleaner.var.name'] <- paste(varNames[382:395,'var.name'],'-X',sep='')
varNames[396:409,'cleaner.var.name'] <- paste(varNames[396:409,'var.name'],'-Y',sep='')
varNames[410:423,'cleaner.var.name'] <- paste(varNames[410:423,'var.name'],'-Z',sep='')
varNames[461:474,'cleaner.var.name'] <- paste(varNames[461:474,'var.name'],'-X',sep='')
varNames[475:488,'cleaner.var.name'] <- paste(varNames[475:488,'var.name'],'-Y',sep='')
varNames[489:502,'cleaner.var.name'] <- paste(varNames[489:502,'var.name'],'-Z',sep='')
#
# The names at this point are still not acceptable R variable names. 
#
# The open and closed parentheses pairs that occur with mean, std, etc 
# can be helpful in identifying the measurements we want to keep
# so I'll leave those intact for the moment.
#
# Next, we'll go through a multi-step process to clean up the names.
# It's not necessary but I'm going to keep the results of each step 
# until I'm satisfied with the result.
#
# Replace all hyphens, underscores and commas with periods.
#
clean1 <- gsub("[-_,]",".", varNames$cleaner.var.name) 
#
# Replace uppercase letters with period followed by the letter
#
clean2 <- gsub("([A-Z])", ".\\1", clean1)
#
# Make the entire name lower case
#
clean3 <- tolower(clean2)
#
# Get rid of the single parentheses
#
clean4 <- gsub("\\(\\.","\\.",clean3)
clean5 <- gsub("\\((t)","\\.\\1", clean4)
clean6 <- gsub("(mean)\\)","\\1", clean5)
clean7 <- gsub("(gravity)\\)","\\1", clean6)
#
# Get rid of the double periods we've created
#
clean8 <- gsub("\\.\\.", "\\.", clean7)
#
# Get rid of the body.body instances (this is surely an error in features.txt)
# This version of the variable names still contains the double parentheses 
# that I want to use to select the variables we will ultimately keep. We'll
# keep this version as 'cleaner.var.name'.
#
varNames$cleaner.var.name <- gsub("body.body","body", clean8)
#
# Finally, remove the double parentheses. Once that
# is done we'll have the clean and descriptive variable names for the 
# tidy data set. We'll name this version 'good.var.name' and keep it in
# varNames.
#
varNames$good.var.name <- gsub("\\(\\)","", varNames$cleaner.var.name)
#
# some clean-up
#
rm(clean1, clean2, clean3, clean4, clean5, clean6, clean7, clean8)
#

# Next, we apply the variable names we cleaned up in an earlier step (cleaning_variable_names.R).
#
# When loaded, the variable names in X are simply V1 ... V561. Now, we'll
# apply our 'good.var.name' to those columns. 
# 
# At the same time, we'll give a descriptive name to the columns in 
# the dataframes subject and y.
#
#
colnames(subject) <- 'subject.id'
colnames(y) <- 'activity.code'
colnames(X) <- varNames$good.var.name
#
# COMPLETION OF WORK TO ACCOMPLISH
# OBJECTIVE 4: Appropriately label the data set with descriptive variable names. 
#
##################################################################################
#
# START OF WORK TO ACCOMPLISH
# OBJECTIVE 3 Use descriptive activity names to name the activities in the data set
#
# Add a variable with the activity description in text form to the y dataframe
# to make it easier to understand the coded activity. 
#
#
# Get the deciphered codes for the activities subjects were asked to perform
# from the file activity_labels.txt (also found in the root directory).
#
activityCodes <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activityCodes)[1] = 'activity.code'
colnames(activityCodes)[2] = 'activity'
#
# Add the activity description to the dataframe y with name 'activity'.
#
y$activity <- activityCodes$activity[y$activity]
#
# END OF WORK TO ACCOMPLISH
# OBJECTIVE 3 Use descriptive activity names to name the activities in the data set
#
##################################################################################
#
# WORK TO COMPLETE
# OBJECTIVE 1 Merge the training and test sets to create one data set
#
# At this point, we have three dataframes, each with 10299 observations.
# Each of the dataframes has columns with descriptive variable names.
#
# Combine the three dataframes (subject, y, and X) into a single master 
# containing the subject.code from subject, the activity.code and the activity 
# from y, and the 561 variables from X for a total of 564 variables 
# (and 10299 observations)
#
master <- cbind(subject, y, X)
# dim(master)
#
# In the table varNames where we have a list of the variables taken from the X
# dataset the variable V1 indicates the columnn number for the variable in the 
# X dataframe. Because we have just added three columns to the start of the 
# dataframe master, the number in V1, if incremented by 3 would reflect the
# column number of the variable in the dataframe master. This can be useful to us
# in the next step.
#
varNames$col.number.in.master <- varNames$column.number.in.X + 3
#
# We need to add the varable in subject (subject.code) and in activity (activity.code)
# to the table with the list of variables
#
# a little bit of clean up
#
rm(X, y, subject, activityCodes)
#
# COMPLETION OF
# OBJECTIVE 1 Merge the training and test sets to create one data set
#
##################################################################################
#
# START OF WORK TO ACCOMPLISH
# OBJECTIVE 2 Extract only the measurements of the mean and standard 
#             deviation for each measurement. 
#
# To do work, I'm going to use dplyr. (This script assumes dplyr is installed.)
#
library(dplyr)
#
# With dplyr, it is helpful to put a wrapper around big data frames using tbl_df.
# This makes it easier to print the frame.
#
master <- tbl_df(master)
#
# First, we have to decide which of the 561 variables taken from X we want to keep.
# We are instructed to keep means and standard deviations.
#
# Most of the variables that are means or standard deviations have names containing the
# text string 'mean()' or 'std()'. The only exception to this is the collection variables
# at the very end containing the phrase 'gravityMean'. I'm not sure these are really meant
# to be kept, but in the interest of being inclusive, I'm going to hold onto them.
#
# I'm going to create a function myFind that will look for a text string in a target
# and a couple of functions that will look for 'mean()' or 'std()' or 'gravityMean'
# can be used to call upon 
#
myFind <- function(pattern, target) {
  if (length(grep(pattern, target)) >0) {
    isFound <- TRUE
  } else {
    isFound <- FALSE
  }
  isFound  
}
myFindMean <- function(target) {
  myFind('mean\\(\\)',target)
}
myFindStd <- function(target) {
  myFind('std\\(\\)',target) 
}
#
# And then use these functions to create three new columns in varNames that will
# indicate that the variable is a mean, a standard deviation or a gravityMean.
#
varNames['a.mean'] <- sapply(varNames$cleaner.var.name, myFindMean)
varNames['a.std'] <- sapply(varNames$cleaner.var.name, myFindStd)
#
# Create a vector containing the names of the variables we want to keep
#
# First, we create a vector identifying the means and stds
# 
varNames['mean.or.std'] <- varNames$a.mean | varNames$a.std 
sum(varNames$mean.or.std)
#
# The sum function reports that there are 66 variables in the data frame
# that are means or stds. 
#
# add subject.code, activity.code and activity which are columns 1, 2 and 3
#
keepThese <- c(TRUE, TRUE, TRUE, varNames$mean.or.std)
#
# Now, we'll use dplyr to select the variables we want to delete or keep
# I'm going to overwrite the original master with the abbreviated
# collection of variables. varNames column 6 is the column position in
# the master file that is to be kept.
#
keepThese <- c(1,2,3,varNames[varNames$mean.or.std==TRUE,6])
master <- select(master, keepThese)
#
# END OF WORK TO ACCOMPLISH
# OBJECTIVE 2 Extract only the measurements on the mean and standard 
#             deviation for each measurement. 
#
# At this point, the dataframe master contains only the 66 features or
# variables that we have elected to keep.
#
##################################################################################
#
# START OF WORK TO ACCOMPLISH
# OBJECTIVE 5: Create a second, independent tidy data set with the average
#              of each variable for each activity and each subject.
#
# DPLYR makes this last step very easy. I'm going to drop the activity code
# from the resulting table since it is no longer needed
#
tidyDS <- master %>% select(-activity.code) %>% group_by(activity,subject.id) %>% summarise_each(funs(mean))
#
# the resulting tidyDS is arranged by activity and then subject (there were 30)
# following that there are the means of the means and standard deviations taken 
# from the original dataframe X.
#
# All that remains now is to write the table out into a form that can be easily
# loaded into R.
#
write.table(tidyDS, file='./data/TidyDS.txt',row.name=FALSE)
#
# The tidy data set can be reloaded into R using a command similar to the following:
# tidyData <- read.table('./data/TidyDS.dat', header=TRUE, sep=',')
#
# END OF WORK TO ACCOMPLISH
# OBJECTIVE 5: Create a second, independent tidy data set with the average
#              of each variable for each activity and each subject.
#
##################################################################################
# 
# END OF PROJECT
#
##################################################################################
