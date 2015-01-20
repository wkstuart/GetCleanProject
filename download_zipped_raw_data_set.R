# download_zipped_raw_data_set.R
# 2015-01-12
#
# this code will copy the project data file from the web to a local directory
# data is to be placed in a subdirectory (/data) of the working directory
#
if (!file.exists('./data')) {
  dir.create('./data')
}
# 
# the data file we are to work with in the project is available on a web site
# the following code will simply download the file and rename it ProjectData.zip
#
fileURL = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileURL, destfile = './data/ProjectData.zip')
list.files('./data')
DateDownloaded <- date()
DateDownloaded
#
# The zipped file was subsequently unzipped into the /data directory
#
# EOF
#