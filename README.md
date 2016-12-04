# Introduction

This is my solution for the final peer assignment in the coursera course "Getting and Cleaning Data".
The original steps were described as: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Files included in this repo as my solution

###readme.me
This file.

###run_analysis.R
The complete script that includes all the steps mentioned above. Please be aware of the following requirements:
- the path in line 7 containing the relevant data directory has to be correct
- the packages dplyr and reshape2 have to be installed.

My solution is not very consise, however I tried to make all steps as clear and easy as possible.
The general approach was to first combine all relevant elements and then to reduce the data. This solution is neither short nor fast, but hopefully easy to understand.

###codebook
The codebook includes all the variable included in the data file.

###tidy.csv
The file produced with the script and mentioned at step 5 above.

