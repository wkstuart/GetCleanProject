# cleaning_variable_names.R
# 2015-01-19
#
# Because we are going to need the names of the 561 variables included in the X_@@@.txt files,
# we must download the names from the file features.txt (found in the root directory).
# We'll load these names into a data frame and give the columns meaningful names
#
varNames <- read.table("./data/UCI HAR Dataset/features.txt")
colnames(varNames) <- c('column.number.in.X', 'var.name')
#
# Unfortunately, there are duplicate variable names in this list. We need to address that problem
# straight away since we want to use these names to identify columns in our final table.
#
# First we'll identify the duplicates.
#
varNames$var.name <- as.character(varNames$var.name)
varNames['duplicate'] <- duplicated(varNames$var.name)
sum(varNames$duplicate)
#
# Since the duplicates occur in patterns of 3, I presume that they should be labeled
# with an X, Y or Z. We're not going to be using these variables with duplicate names
# anyway because they are neither means nor standard deviations. We'll fix the problem
# by simply adding X, Y or Z to the duplicate names.
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
# The names as they stand are not acceptable R variable names. We need to clean them
# up. 
#
# I'll keep the open and closed parentheses pairs that occur with mean, std, etc and use
# them later to identify the variables I want to retain.
#
# Replace hyphens, underscores and commas with periods.
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
# keep this version as cleaner.var.name.
#
varNames$cleaner.var.name <- gsub("body.body","body", clean8)
#
# But finally we will need to remove the double parentheses. Once that
# is done we'll have the clean and descriptive variable names for the 
# tidy data set. We'll name this version good.var.name.
#
varNames$good.var.name <- gsub("\\(\\)","", varNames$cleaner.var.name)
#
# And we are going to need the codes for the activities subjects were asked to perform.
# These can be taken from the file activity_labels.txt (also found in the root directory).
#
activityCodes <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
colnames(activityCodes)[1] = 'activity.code'
colnames(activityCodes)[2] = 'activity'
#
# some clean-up
#
rm(clean1, clean2, clean3, clean4, clean5, clean6, clean7, clean8)
#
# EOF
#