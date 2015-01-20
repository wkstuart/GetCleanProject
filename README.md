# JH_GetCleanProj

This GIT repository contains all of the components of the required project for Getting and Cleaning Data, a Coursera course from Johns Hopkins University and the third course of a nine part series of courses on Data Science.

##The Raw Data

The data for this project was provided by the Coursera course instructors. The data set downloads as a single zipped file with multiple subdirectories. The zipped file (ProjectData.zip) was subsequently unzipped into the /data directory.

The extracted data (in /data) has the following structure:
  /UCI HAR Dataset
    /test                     the test data sets (each file contains 7352 observations)
      /Inertial Signals
      subject_test.txt        dataset containing an id for the subject performing each observation
      X_test.txt              dataset containing 561 measurements for each observation
      y_test.txt              dataset containing the activity performed for each observation
    /train                    the training data sets (each file contains 7352 observations)
      /Inertial Signals
      subject_test.txt        same as test data sets
      X_test.txt              
      y_test.txt    
    activity_labels.txt       textual description of the six numbered activities
    features.txt              a list of the 561 measurements included in X_test.txt  
    features_info.txt         a codebook for the 561 measurements
    README.txt

The data is from the Center for Machine Learning and Intelligent Systems at the Donald Bren School of Information and Computer Sciences at the University of California, Irvine.

The data comprises readings taken from Samsung Galaxy S II mobile phones attached to the waist of 30 volunteers who perfomed a collection of six activities: walking, walking upstairs, walking downstairs, sitting, standing and lying down.

For the purposes of analysis, the raw data sets were randomly partitioned into a training set (70% of the total data) and a test set (30% of the total data).

Citation for the data: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

More complete information on the data can be found [here] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

##Acquiring the raw data from the web

The script file download_zipped_raw_data_set.R was used to download the dataset from the web and place the zip file names ProjectData.zip in the /data directory.

##Extracting the raw data from the downloaded file

The script file extract_data_sets_from_zip_file.R was used to extract the test and training data sets that the project instructions require. There are three test datasets and three training datasets named subject_train, X_train, y_train, subject_test, X_test, and y_test. These six datasets will be combined in run_analysis.R.

##Cleaning and assigning variable names to the measurements provided in the X datasets.

The script file applying_variable_names.R was used to clean up the names of the variables included in the X datasets and to apply those cleaned names to themaster

The file features.txt included in the downloaded data provides a list of names for the 561 measurements. Unfortunately, the list presents us with a number of problems. There are duplicate names in the list, apparently because the X, Y, and Z axis component of the name were inadvertently omitted. Also, the names contain characters that are unacceptable for use in R. 

I have tried to make the variable names conform to the Google's R Style Guide. I have elected not to expand the names for use in the tidy dataset to enhance readability but will  instead will provide clarification in the Codebook.

##The project requirements

The script file run_analysis.R contains the code to complete the operations required by the project assignment.

**Step 1. **

The training and test datasets are to be merged into a single dataset. I have elected to do a row bind on each training/test pair before performing a column bind to join the three resulting datasets.

**Step 2. **

Extract only the mean and standard deviation measurements. In this step, I have elected to keep only those measurements that were identified in features.txt with either a mean() or std() suffix. There are other measurements whose name contains the word mean, but I have elected not to include them in this data set since they are angles between two vectors and not means. It would be easy enough to include these variables if desired.

**Step 3. **

The activity codes provided in the y dataset are to be replaced by textual activity names. This step is completed out of order. It can be found in Step 1.

**Step 4. **

The variable names in the table are to be made readable and workable. I have elected to complete this step before performing Step 2. In this way I have applied a workable variable name to all of the 561 "features" from the X datasets before subsetting the table to select only means and standard deviations.

**Step 5.**

From the data set in step 4, create a second, independent tidy data 
set with the average of each variable for each activity and each subject. This resulting tidy data set has been saved in the /data directory as tidyDS.dat using the R function write.table. (The command to load the dataset into R can be found at the very end of the script run_analysis.R)





