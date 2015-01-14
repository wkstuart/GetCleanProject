# extract__data_sets_from_zip_file.R
# 2015-01-12
#
# the following code will read the required data sets into dataframes corresponding
# to the raw data files.
#
# we will extract the following six data sets 
#  1. subject_train.txt -> subject_train
#  2. X_train.txt       -> X_train
#  3. y_train.txt       -> y_train
#  4. subject_test.txt  -> subject_test
#  5. X_test.txt        -> X_test
#  6. y_test.txt        -> y_test
#
# first, the training files
#
subject_train <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/train/subject_train.txt"))
X_train <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/train/y_train.txt"))
#
# next, the test files
#
subject_test <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/test/subject_test.txt"))
X_test <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/test/y_test.txt"))
#
# the training set has 7352 observations
# the test set has 2947 observations
#
# Because we are going to need the names of the 561 variables included in the X_@@@.txt files,
# we must download the names from the file features.txt (found in the root directory).
# We'll load these names into a data frame and give the columns meaningful names
#
varNames <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/features.txt"))
colnames(varNames) <- c('column_number_in_X', 'var_name')
#
# Unfortunately, there are duplicate variable names in this list. We need to address that problem
# straight away since we want to use these names to identify columns in our final table.
#
# First we'll identify the duplicates.
#
varNames$var_name <- as.character(varNames$var_name)
varNames['duplicate'] <- duplicated(varNames$var_name)
sum(varNames$duplicate)
#
# Since the duplicates occur in patterns of 3, I presume that they should be labeled
# with an X, Y or Z. We're not going to be using these variables with duplicate names
# anyway because they are neither means nor standard deviations. We'll fix the problem
# by simply adding X, Y or Z to the duplicate names.
#
varNames['good_var_name'] <- varNames$var_name
varNames[303:316,'good_var_name'] <- paste(varNames[303:316,'var_name'],'-X',sep='')
varNames[317:330,'good_var_name'] <- paste(varNames[317:330,'var_name'],'-Y',sep='')
varNames[331:344,'good_var_name'] <- paste(varNames[331:344,'var_name'],'-Z',sep='')
varNames[382:395,'good_var_name'] <- paste(varNames[382:395,'var_name'],'-X',sep='')
varNames[396:409,'good_var_name'] <- paste(varNames[396:409,'var_name'],'-Y',sep='')
varNames[410:423,'good_var_name'] <- paste(varNames[410:423,'var_name'],'-Z',sep='')
varNames[461:474,'good_var_name'] <- paste(varNames[461:474,'var_name'],'-X',sep='')
varNames[475:488,'good_var_name'] <- paste(varNames[475:488,'var_name'],'-Y',sep='')
varNames[489:502,'good_var_name'] <- paste(varNames[489:502,'var_name'],'-Z',sep='')
#
# The names are not very clean and need to have the parentheses removed from them.
# We'll also replace all the dashes by underscores since the dashes are interpreted
# as operators. And the commas can be replaced by underscores as well
#
varNames$good_var_name <- gsub("\\(","", varNames$good_var_name) # eliminate left parens
varNames$good_var_name <- gsub("\\)","", varNames$good_var_name) # eliminate right parens
varNames$good_var_name <- gsub("-","_", varNames$good_var_name) # eliminate right parens
varNames$good_var_name <- gsub(",","_", varNames$good_var_name) # eliminate right parens
#
# And we are going to need the codes for the activities volunteers were asked to perform.
# These can be taken from the file activity_labels.txt (also found in the root directory).
#
activityCodes <- read.table(unz("./data/ProjectData.zip", "UCI HAR Dataset/activity_labels.txt"))
colnames(activityCodes)[1] = 'activity_code'
colnames(activityCodes)[2] = 'activity'
#
# EOF
#