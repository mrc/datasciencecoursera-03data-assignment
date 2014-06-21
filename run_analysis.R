# run_analysis.R

# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(reshape2)

dataset_path = "UCI HAR Dataset"

#nrows = 1000
#some_data_measurements <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE, nrows=nrows)
#some_data_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE, col.names="subject", nrows=nrows,  colClasses="factor")
#some_data_activities <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE, col.names="activity", nrows=nrows)

# Inputs:
#   dataset is a list with elements "measurements", "activities" and "subjects"
#   activity_labels and feature_labels are frames with 
# Output:
#   A data.frame with columns: subject, activity, feature, measurement.
#   Only measurements on the mean and standard deviation are included.
getLabelledMeasurements <- function(dataset, activity_labels, feature_labels) {
        # number measurement columns; they are our index into the feature labels table
        names(dataset$measurements) <- seq_along(names(dataset$measurements))
        
        # we are only interested in features with "-mean()" or "-std()" in their names
        interesting_features <- grep(pattern = "-(mean|std)\\(\\)", x = feature_labels$label)
        
        # build a frame of: subject, activity, feature, measurement
        # including only measurements we are interested in. We cast
        # variable to a character as it is a look-up into the feature
        # labels table.
        data <- with(dataset, cbind(subjects, activities, measurements[,interesting_features]))
        data <- melt(data, id=c("subject", "activity"), variable.name="feature", value.name="measurement")
        
        # replace activities and features with their descriptive names
        data$activity <- activity_labels[data$activity,]
        data$feature <- feature_labels[levels(data$feature),]
        
        data
}

readDataSubset <- function(subset_name, ...) {
        subset_path = file.path(dataset_path, subset_name)
        
        measurements_file = file.path(subset_path, paste0("X_", subset_name, ".txt"))
        activities_file = file.path(subset_path, paste0("y_", subset_name, ".txt"))
        subjects_file = file.path(subset_path, paste0("subject_", subset_name, ".txt"))
        
        measurements <- read.table(measurements_file, header=FALSE, ...)
        subjects <- read.table(subjects_file, header=FALSE, col.names="subject", colClasses="factor", ...)
        activities <- read.table(activities_file, header=FALSE, col.names="activity", ...)
        
        list(measurements=measurements, subjects=subjects, activities=activities)
}

# Returns:
#   a data.frame with columns: subject, activity, feature, measurement.
readDataSet <- function(...) {
        features_file = file.path(dataset_path, "features.txt")
        feature_labels <- read.table(features_file, header=FALSE,
                                     row.names=1, col.names=c("id", "label"),
                                     colClasses=c("factor", "factor"))
        
        activity_labels_file = file.path(dataset_path, "activity_labels.txt")
        activity_labels <- read.table(activity_labels_file, header=FALSE,
                                      row.names=1, col.names=c("id", "label"),
                                      colClasses=c("factor", "factor"))
        
        test_set <- readDataSubset("test", ...)
        test_data <- getLabelledMeasurements(test_set, activity_labels, feature_labels)
        training_set <- readDataSubset("train", ...)
        training_data <- getLabelledMeasurements(training_set, activity_labels, feature_labels)
        
        rbind(test_data, training_data)
}

data_set <- readDataSet(nrows=-1)


#some_data <- getLabelledMeasurements(some_data_measurements, some_data_subjects, some_data_activities, activity_labels, feature_labels)

