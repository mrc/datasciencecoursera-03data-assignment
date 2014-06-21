# About

The script "run_analysis.R" generates a tidy data set "tidy.txt" according
to the requirements of Assignment 2.

You should create one R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

The script assumes that it is run in the directory that the provided data
set "UCI HAR Dataset" has been unzipped in.

# Choices

Included are measurements with "-std()" and "-mean()" in their names.
Measurements with names such as "-meanFreq()" in their name have not been
included.
