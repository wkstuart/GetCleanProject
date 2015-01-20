# run_analysis.R
# 2015-01-12
#
# the following code performs the operations specified by the
# Johns Hopkins Coursera Course Getting and Cleaning Data 
# course project instructions (stated below)
#
# 1 Merges the training and the test sets to create one data set.
# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
# 5 From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
#
##################################################################################
#
# 1 Merge the training and test sets to create one data set
#
# The raw data must be extracted from a downloaded zip file.
# The data is partitioned overall into a training and test data set.
# Each of the two partitions contains three files 
#   1. subject_@@@.txt contains a subject identifier for each observation
#   2. y_@@@.txt contains an activity identifier for each observation
#   3. X_@@@.txt contains 561 variables for each observation
# where @@@ is either 'train' or 'test'.
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
# The resulting merged sets, subject, X and y each have 10299 observations.
#
# Next, we apply the variable names we cleaned up in an earlier step (cleaning_variable_names.R).
#
# When loaded, the variable names in master are simply V1 ... V561.
#
# The list of 561 cleaned variable names is contained in the dataframe 
# varNames created cleaning_variable_names.R. When these 
#
colnames(subject) <- 'subject.id'
colnames(y) <- 'activity.code'
colnames(X) <- varNames$good.var.name
#
# And, while we're at it, let's add to y a variable with the activity named
# to make it easier to understand what activities are being performed.
#
# This is actually what is required by Step 3. 
#
y$activity <- activityCodes$activity[y$activity]
#
# Next, we will combine the three sets into a single master data frame
# containing the subject.code from subject, the activity.code and the activity 
# from y, and the 561 variables from X for a total of 564 variables 
# (and 10299 observations)
#
master <- cbind(subject, y, X)
dim(master)
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
rm(X, y, subject)
#
##################################################################################
#
# 2 Extract only the measurements on the mean and standard deviation for each measurement. 
#
# To do this next step, I'm going to use dplyr. (This assumes dplyr is installed.)
#
library(dplyr)
#
# With dplyr, it is helpful to put a wrapper around big data frames using tbl_df.
# This makes it much easier to print the frame.
#
master <- tbl_df(master)
#
# First, we have to decide which of the 561 variables that were taken from X we want to keep.
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
# END of processing to accomplish objective 2 (and 3 and 4)
#
##################################################################################
#
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
#
# At this point, we've accomplished objectives 3 and 4. The activities
# were completed out of order but have been completed.
#
# Step 3 was completed in the Step 1 operations when the variable 
# activity was added to the y dataset. 
#
# Step 4 was completed in the Step 2 operations. I used the cleaned
# variable names to select the variables that were to be retained.
# 
# So we're going on without further activity to step 5
#
# END of objectives 3 and 4
#
##################################################################################
#
# 5 From the data set in step 4, create a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
#
# dplyr makes this last step very easy. I'm going to drop the activity code
# from the resulting table since it is effectively included in the activity
#
tidyDS <- master %>% select(-activity.code) %>% group_by(activity,subject.id) %>% summarise_each(funs(mean))
#
# the resulting tidyDS is arranged by activity and then subject (there were 30)
# following that there are the means of the 85 means and standard deviations taken from X.
#
# all that remains now is to write the table out into a form that can be easily
# loaded into R
#
write.table(tidyDS, file='./data/TidyDS.dat',sep=',')
write.csv(tidyDS, file='./data/TidyDS.csv')
#
# the tidy data set can be reloaded into R using a command similar to the following:
# tidyData <- read.table('./data/TidyDS.dat', header=TRUE, sep=',')
#
# END of objective 5
#
##################################################################################
