## Coursera: Getting and Cleaning Data
### Codebook

Analysis of for converting raw data into tidy data includes following steps

Prep Step (Getdata): The script download raw data using URL provided in assignment.
Unzips and data into current directory.
This creates a directory "UCI HAR Dataset" in your current working directory.
This directory will have all txt data files and other supporting files in two directories "test" and "trng" data

* Step 1: The analysis addresses the training and test data separately, 
first combining the feature vector with outcome variables and subject identifiers 
(e.g. X_train.txt, Y_train.txt, subject_train.txt), and then merges the test and training data into a single, larger dataset.

* Step 2: Extracts the measurements on the mean and standard deviation for each measurement. 
Build column list (measures) which has mean or STD from features.txt.
Using this list extract only matchinh columne from dataset.

* Step 3:Assign descriptive names to columns in data set. 
Get descriptive names from activity_labels.txt
Add activity label for each activity in data set.

* Step 4: Make each column description name more readable and easy to remember
Generated data set column names are not easy to read for example "tBodyAcc-mean()-Y"
convert then to more readable format like "TimeBodyAccMeanY"

* Step 5: Perform aggregate functions on data set to find mean values for each subject and activity combination.
Rename and Reorder columns easy to read and follow.
Tidy data set output is saved in a TidyData.txt file.

* Step verification: This is an optional step.
This step helps to assure generated file has clean/tidy data for further data analysis.
load the generated TidyData.txt file into a data set

Run R Script file run_analysis.R from console.
If zip file is downloaded in current working directory the script will skip download step. 
