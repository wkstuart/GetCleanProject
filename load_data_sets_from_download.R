# load_data_sets_from_download.R
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
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
#
# next, the test files
#
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
#
# the training set has 7352 observations
# the test set has 2947 observations
#
# EOF
#