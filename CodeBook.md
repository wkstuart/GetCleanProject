#CodeBook.md

This is the codebook for the tidy dataset in my project submission for the Johns Hopkins Coursera course Getting and Cleaning Data

#Data Source

The data is from the Center for Machine Learning and Intelligent Systems at the Donald Bren School of Information and Computer Sciences at the University of California, Irvine.

The data comprises readings taken from Samsung Galaxy S II mobile phones attached to the waist of 30 volunteers who perfomed a collection of six activities: walking, walking upstairs, walking downstairs, sitting, standing and lying down.

For the purposes of analysis, the raw data sets were randomly partitioned into a training set (70% of the total data) and a test set (30% of the total data).

A more complete description of the data can be found in the file /data/UCI HAR Dataset/README.txt.

A more complete description of the features (or variables) provided in the original datasets can be found in the file /data/UCI HAR Dataset/features_info.txt.

Citation for the data: [1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

More complete information on the data can be found [here] (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones#)

#The tidy data set

The tidy data set is a table of 180 cases (30 subjects x 6 activities) with mean values for 68 features or variables. There is one record for each of the 30 subjects performing each of the 6 activities.

All values for the 64 features or variables in this dataset are means of previously normalized values (unitless values from -1 to 1) from 64 of the 561 features provided in the original data sets. 

The 68 features or variables summarized in the dataset are the following:

Note 1: A leading t in the variable name indicates a time domain variable.
        A leading f in the variable name indicates a frequency domain variable.
      
Note 2: The abbreviation 'acc' refers to linear acceleration
        
01 activity
  the activity performed by the subject
    WALKING
    WALKING_UPSTAIRS
    WALKING_DOWNSTAIRS
    SITTING
    STANDING
    LAYING 
    
02 subject.id
  the subject identifier [1:30]
  
03 t.body.acc.mean.x
  
04 t.body.acc.mean.y

05 t.body.acc.mean.z

06 t.body.acc.std.x

07 t.body.acc.std.y

08 t.body.acc.std.z

09 t.gravity.acc.mean.x

10 t.gravity.acc.mean.y

11 t.gravity.acc.mean.z

12 t.gravity.acc.std.x

13 t.gravity.acc.std.y

14 t.gravity.acc.std.z

15 t.body.acc.jerk.mean.x

16 t.body.acc.jerk.mean.y

17 t.body.acc.jerk.mean.z

18 t.body.acc.jerk.std.x

19 t.body.acc.jerk.std.y

20 t.body.acc.jerk.std.z

21 t.body.gyro.mean.x

22 t.body.gyro.mean.y

23 t.body.gyro.mean.z

24 t.body.gyro.std.x

25 t.body.gyro.std.y

26 t.body.gyro.std.z

27 t.body.gyro.jerk.mean.x

28 t.body.gyro.jerk.mean.y

29 t.body.gyro.jerk.mean.z

30 t.body.gyro.jerk.std.x

31 t.body.gyro.jerk.std.y

32 t.body.gyro.jerk.std.z

33 t.body.acc.mag.mean

34 t.body.acc.mag.std

35 t.gravity.acc.mag.mean

36 t.gravity.acc.mag.std

37 t.body.acc.jerk.mag.mean

38 t.body.acc.jerk.mag.std

39 t.body.gyro.mag.mean

40 t.body.gyro.mag.std

41 t.body.gyro.jerk.mag.mean

42 t.body.gyro.jerk.mag.std

43 f.body.acc.mean.x

44 f.body.acc.mean.y

45 f.body.acc.mean.z

46 f.body.acc.std.x

47 f.body.acc.std.y

48 f.body.acc.std.z

49 f.body.acc.jerk.mean.x

50 f.body.acc.jerk.mean.y

51 f.body.acc.jerk.mean.z

52 f.body.acc.jerk.std.x

53 f.body.acc.jerk.std.y

54 f.body.acc.jerk.std.z

55 f.body.gyro.mean.x

56 f.body.gyro.mean.y

57 f.body.gyro.mean.z

58 f.body.gyro.std.x

59 f.body.gyro.std.y

60 f.body.gyro.std.z

61 f.body.acc.mag.mean

62 f.body.acc.mag.std

63 f.body.acc.jerk.mag.mean

64 f.body.acc.jerk.mag.std

65 f.body.gyro.mag.mean

66 f.body.gyro.mag.std

67 f.body.gyro.jerk.mag.mean

68 f.body.gyro.jerk.mag.std



