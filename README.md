=============================================
JHU Getting and Cleaning Data Course Project
Feb 22 2015
=============================================
Jonathan Stahlman
=============================================

The purpose of this project is to collect, work with, and clean an example 
data set with the ultimate goal of preparing a tidy data set that can be used 
for later analysis. 

The data set consists of acceleration and angular velocity data recorded by 
smartphones as a number of subjects were doing various activities such as sitting 
or walking. The data is sourced from the UCI Machine Learning Repository:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The task at hand is summarized by the following steps:

1. Merge the training and the test sets to create one data set.
2. Extract the measurements on the mean and standard deviation for each measurement. 
3. Use descriptive activity names to name the activities in the data set
4. Appropriately label the data set with descriptive variable names. 
5. Output an independent tidy data set consisting of the average of each 
   variable for each activity and each subject.

After sourcing 'run_analysis.R', an output file named 'means.txt' containing the 
tidy data set is created.  To quickly examine the output in R, run:

  View(read.table('means.txt',header=TRUE))

This package includes the following files:
=========================================

- 'README.txt'

- 'CodeBook.md': Gives description of each output variable

- 'run_analysis.R': Script to produce tidy data set
