Getting_and_Cleaning_Data_Course_Project
========================================

This document describes the variables, the data, and any transformations or work that I performed to clean up the data.

I last downoaded the data collected from the accelerometers from the Samsung Galaxy S smartphone on Saturday June, 21.
Summaries of the raw training and test data were provided, but each class (training and test) was separated into three files:

1.  "subject_test" - the subjects that performed the activities
2.  "y_test" - the activities performed by id.
3.  "x_test" - the activity measurements.

For both training and test data, I combined these three files by binding the columns.
The training and test sets were then combined by appending the rows.
The measurement names were provided in the file "features".
Our assignment was to only analyze the data for mean and standard deviation, so I identified these columns by searching for the text "mean" and "std", ignoring case.
This strategy may have resulted in a few too many feature "means" (there were certainly more mean measurements than std measurements for some reason), but better to include too much that omit something important.
The key for the activity names was provided in the file "activities".  I merged these descriptive names to the data set by activity id.
The feature names were a little messy, because they included punctuation characters "()-".  I removed instances of "()", transformed "-" to "_", and transformed orphan "(" and ")" to "_".
I then added the cleaned-up feature names to the data set as column names.
In order to aggregate the mean of each feature data by activity and subject, I "melted" the data using the package "reshape2", with person id, activity, and activity id as the IDs, and all the features as variables.
Then, I cast the data with the mean function.  The result is one row for each person/activity, and the mean of each feature.  The final output is a csv file "tidy_data.csv" which contains 180 observations and 88 columns.  The first two columns identify the activity and the person id, and the remaining 86 columns are the various mean and standard deviation measurements.


