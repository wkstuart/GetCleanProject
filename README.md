# README.md

This GIT repository contains all of the components of the required project for Getting and Cleaning Data, a Coursera course from Johns Hopkins University and the third course of a nine part series of courses on Data Science.

##The Raw Data

The data for this project was provided by the Coursera course instructors. The data set downloads as a single zipped file with multiple subdirectories. The zipped file (ProjectData.zip) was subsequently unzipped into the /data directory.

The extracted data (in /data) has the following structure:
*/UCI HAR Dataset
*  /test                     the test data sets (each file contains 7352 observations)
*    /Inertial Signals
*    subject_test.txt        dataset containing an id for the subject performing each observation
*     X_test.txt              dataset containing 561 measurements for each observation
*     y_test.txt              dataset containing the activity performed for each observation
*  /train                    the training data sets (each file contains 7352 observations)
*    /Inertial Signals
*    subject_test.txt        same as test data sets
*     X_test.txt              
*     y_test.txt    
*  activity_labels.txt       textual description of the six numbered activities
*  features.txt              a list of the 561 measurements included in X_test.txt  
*  features_info.txt         a codebook for the 561 measurements
*  README.txt

The data is from the Center for Machine Learning and Intelligent Systems at the Donald Bren School of Information and Computer Sciences at the University of California, Irvine.

The data comprises readings taken from Samsung Galaxy S II mobile phones attached to the waist of 30 volunteers who perfomed a collection of six activities: walking, walking upstairs, walking downstairs, sitting, standing and lying down.

For the purposes of analysis, the raw data sets were randomly partitioned into a training set (70% of the total data) and a test set (30% of the total data).

Citation for the data: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

More complete information on the data can be found [here.] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

##Acquiring the raw data from the web

The script file download_zipped_raw_data_set.R was used to download the dataset from the web and place the zip file names ProjectData.zip in the /data directory.

This script needs to be run only once to place the raw data in a local directory.

##Extracting the raw data from the downloaded file

The script file extract_data_sets_from_zip_file.R was used to extract the test and training data sets that the project instructions require. There are three test datasets and three training datasets named subject_train, X_train, y_train, subject_test, X_test, and y_test. These six datasets will be combined in run_analysis.R.

This script can be run many times to extract the datasets we will use from the raw data files and put them in R dataframes.

##The project requirements

The script file run_analysis.R contains the code to complete the objectives of the project assignment. The script file is heavily annotated.

**Objective 1 **

Merge the training and test datasets into a single dataset: I have elected to do a row bind on each training/test pair before performing a column bind to join the three resulting datasets.

**Objective 2 **

Extract only the mean and standard deviation measurements: I have elected to keep only those measurements that were identified in features.txt with either a mean() or std() suffix. There are other measurements whose name contains the word mean, but I have elected not to include them in this data set since they are angles between two vectors and not means. It would be easy enough to include these variables if desired.

**Objective 3 **

Replace the activity codes provided in the y dataset with a textual description. Ihave used the small codebook activity_labels.txt provided with the raw data to identify the activities more clearly.

**Objective 4 **

Make the variable names readable and workable: I have eapplied a workable variable name to all of the 561 "features" from the X datasets before subsetting the table to select only means and standard deviations.

The file features.txt included in the downloaded data provides a list of names for the 561 measurements. Unfortunately, the list presents us with a number of problems. There are duplicate names in the list, apparently because the X, Y, and Z axis component of the name were inadvertently omitted. Also, the names contain characters that are unacceptable for use in R. 

I have tried to make the variable names conform to the Google's R Style Guide and have elected not to expand the names for use in the tidy dataset to enhance readability but instead to provide more clarification in the Codebook.

**Objective 5 **

From the data set in step 4, create a second, independent tidy data 
set with the average of each variable for each activity and each subject: I have accomplished this final objective using the dplyr library. Th resulting tidy data set has been saved in the /data directory as tidyDS.dat using the R function write.table. (The command to load the dataset into R can be found below.)

## The Tidy Data Set

The data set is tidy because it meets these requirements:
  1. Each variable forms a column
  2. Each observation forms a row
  3. Each type of observational unit forms a table
  
We have only one type of observational unit and only one table in this instance. 

Each observation consists of two fixed variables (subject.id and activity) and 66 measured variables (the mean of the measurements of 66 features for the given subject.id and activity). Because there were 30 subjects performing each of 6 activities, there are 180 observations or records in the resulting dataset.

The resulting dataset has 68 columns representing the 2 fixed variables and the 66 measured variables. All columns are named with descriptive variable names.

The tidy data set can be reloaded into R using a command similar to the following:

> tidyData <- read.table('./data/TidyDS.dat', header=TRUE, sep=',')






