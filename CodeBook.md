# Code Book for the course project
Original provided data source: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
The code assumes that it is saved in the same folder as the downloaded data.  
Libraries `dplyr` and `data.table` are needed for this code to run. 

# Variables description:
`train_X`, `train_y`, `test_X`, `test_y`, `train_subject` and `test_subject` contain the data from the downloaded files, 
which are described in more detail in the README file included in the downloaded folder.  
`labels` contain proper activity names.  
`features` contain variable names.  

# R code steps:
File `run_analysis.R` contains following steps:
1. Downloading the data
2. Unzipping the data
3. Loading the data into R 
4. Properly naming the variables 
5. Merging the data to create one big data frame 
6. Filtering the data by selecting only the columns that contain strings "mean" or "std"
7. Calculating the average for each column, grouped by subject and activity 
8. Saving the new data frame in both .txt and .csv format.

