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
#
# Next, we apply the variable names in varNames to the data frame named X.
# When loaded, the variable names are simply V1 ... V561. After this operation
# they will have more meaningful names.
#
colnames(subject) <- 'volunteer_code'
colnames(y) <- 'activity_code'
colnames(X) <- varNames$good_var_name
#
# And, while we're at it, let's add to y a variable with the activity named
# to make it easier to understand what activities are being performed
#
y$activity <- activityCodes$activity[y$activity]
#
# Next, we will combine the three sets into a single master data frame
# containing the volunteer_code from subject, the activity_code and the activity 
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
varNames$col_number_in_master <- varNames$column_number_in_X + 3
#
# We need to add the varable in subject (subject_code) and in activity (activity_code)
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
# To do this next step, I'm going to use dplyr. This assumes dplyr is installed.
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
  myFind('mean()',target)
}
myFindStd <- function(target) {
  myFind('std()',target) 
}
myFindGrav <- function(target) {
  myFind('gravityMean',target) 
}
#
# And then use these functions to create three new columns in varNames that will
# indicate that the variable is a mean, a standard deviation or a gravityMean.
#
varNames['a_mean'] <- sapply(varNames$var_name, myFindMean)
varNames['a_std'] <- sapply(varNames$var_name, myFindStd)
varNames['a_gravityMean'] <- sapply(varNames$var_name, myFindGrav)
#
# Create a vector containing the names of the variables we want to keep
#
# First, we create a vector identifying the means and stds
# 
varNames['mean_or_std'] <- varNames$a_mean | varNames$a_std | varNames$a_gravityMean
sum(varNames$mean_or_std)
#
# The sum function reports that there are 85 variables in the data frame
# that are means or stds. 
#
# add subject_code, activity_code and activity which are columns 1, 2 and 3
#
keepThese <- c(TRUE, TRUE, TRUE, varNames$mean_or_std)
#
# Now, we'll use dplyr to select the variables we want to delete or keep
# I'm going to overwrite the original master with the abbreviated
# collection of variables
#
keepThese <- c(1,2,3,varNames[varNames$mean_or_std==TRUE,5])
master <- select(master, keepThese)
#
# END of processing to accomplish objective 2 (and 3 and 4)
#
##################################################################################
#
# 3 Uses descriptive activity names to name the activities in the data set
# 4 Appropriately labels the data set with descriptive variable names. 
#
# At this point, I think we've accomplished objectives 3 and 4.
# The column named 'activity' in master is a textual version of the activity
# The columns taken from X all now have descriptive names (incomprehensible,
# perhaps, but descriptive).
#
# So we're going on without further activity to step 5
#
# END of objectives 3 and 4
#
##################################################################################
#
# 5 From the data set in step 4, creates a second, independent tidy data 
# set with the average of each variable for each activity and each subject.
#
# dplyr makes this last step very easy.
#
tidyDS <- master %>% select(-activity_code) %>% group_by(activity,volunteer_code) %>% summarise_each(funs(mean))
view(tidyDS)
#
# the resulting tidyDS is arranged by activity and then volunteer (there were 30)
# following that there are the means of the 85 means and standard deviations taken from X.
#
# END of objective 5
#
##################################################################################
