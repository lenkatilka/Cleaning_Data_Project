run_analysis<-function()
{
  ## load needed libraries
  library(dplyr)
  library(tidyr)
  
  ## loading the train data
  train_set<-read.table("./train/X_train.txt")
  train_labels<-read.table("./train/y_train.txt")
  train_sub<-read.table("./train/subject_train.txt")
  train_id<-rep(1,each=nrow(train_set))   ## indicates if the data is train data or not
  train<-cbind(train_sub,train_labels,train_sub,train_id)   ## clippind train data together
  print("train set loaded")
  
  ## getting rid of old variables (makes space in computing memory)
  train_set<-NULL
  train_labels<-NULL
  train_sub<-NULL
  train_id<-NULL
  
  ## loading test set
  test_set<-read.table("./test/X_test.txt")
  test_labels<-read.table("./test/y_test.txt")
  test_sub<-read.table("./test/subject_test.txt")
  train_id<-rep(0,each=nrow(test_set))   ## indicates if the data is train data or not
  test<-cbind(test_sub,test_labels,test_sub,train_id)    ## clippind test data together
  print("test set loaded")
  
  ## getting rid of old variables (makes space in computing memory)
  test_set<-NULL
  test_labels<-NULL
  test_sub<-NULL
  train_id<-NULL
  
  ## clipping all data together
  data<-rbind(train,test)
  
  ## reading feature names and assigning names() to the variables
  features<-read.table("features.txt")
  features<-data.frame(id_feat=features[,1],motion=features[,2])
  print(dim(features))
  ## find all variables that indicate the mean
  good_mean<-mapply(function(x) grepl("^[^_]+mean",x), features$motion)
  ## find all variables that indicate the standard dev
  good_std<-mapply(function(x) grepl("^[^_]+dev",x), features$motion)
  ## apply 'OR' operator on good_std and good_mean to find which variables contain 'std' or 'mean'
  good<-good_mean|good_std
  print(length(good))
  good<-c(TRUE,TRUE,good) ## need to add TRUE, TRUE for the 1st and 2nd column, which show label and subject idta
  data<-data[good]
  print("data with mean and std selected")
  
  ## replacing activity id with description name
  activity<-read.table("activity_labels.txt")
  train_activities<-mapply(function(x) x<-as.character(activity[x,2]), train_labels)
  test_activities<-mapply(function(x) x<-as.character(activity[x,2]), test_labels)
  data[,2]<-c(train_activities, test_activities)## replaces 2nd column with activity names
  
  ## naming variables with descriptive names and cleaning descriptive names
  features<-features[good_mean|good_std,]
  #### replace special characters in features by dots and assign to new variable
  feat_names<-gsub("[[:punct:]]",".",features[,2])
  #### replace ...BodyBody... 'mistake' in variables to a ...Body...
  feat_names<-gsub("BodyBody","Body",feat_names)
  names(data)<-c("sub_id","activity",feat_names,"train_id")
  print("decriptive names added to data")
  
  ## gather data to have one column with all measures, key called "measure", and value called "value"
  data<-gather(data,measure,value,3:(ncol(data)-1))
  ## group data so that the mean can be computed for each activity and measure
  by<-group_by(data,sub_id,activity,train_id,measure)
  ## taking mean of the "value" column per each activity and measure
  data_avg<-summarize(by,mean=mean(value))
  ## output the tidy average data
  write.table(data_avg,file="UCI_HAR_Dataset_averages_tidy.txt",row.names=FALSE)
}