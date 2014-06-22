# Check if the data exists in the home documents folder.  If not, download and unzip.
setwd("~/Documents")
if (!file.exists("UCI HAR Dataset")) {
        fileURL="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        Local_Name="HAR.zip"
        download.file(url=fileURL, dest = Local_Name)
        # On a Mac, you may need to add method=curl to the previous command
        dateDownloaded <- date()
        unzip(Local_Name)
}
# Load the summary data
setwd("~/Documents/UCI HAR Dataset")
features<-read.table("features.txt")
activities<-read.table("activity_labels.txt")
# Load the Test data and combine.
setwd("~/Documents/UCI HAR Dataset/test")
subject_test<-read.table("subject_test.txt")
x_test<-read.table("x_test.txt")
y_test<-read.table("y_test.txt")
full_test<-cbind(subject_test,y_test,x_test)
# Load the Train data and combine
setwd("~/Documents/UCI HAR Dataset/train")
subject_train<-read.table("subject_train.txt")
x_train<-read.table("x_train.txt")
y_train<-read.table("y_train.txt")
full_train<-cbind(subject_train,y_train,x_train)
# Combine Train and Test data
full_set<-rbind(full_test,full_train)
# Subset for features with mean or std in title.  
features$mean<-grepl("mean",features$V2,ignore.case=TRUE)
features$std<-grepl("std",features$V2,ignore.case=TRUE)
extract<-features[features$mean|features$std,]
extract$V3<-extract$V1+2
extract_set<-subset(full_set,select=c(1,2,extract$V3))
# Add a column with activity names
colnames(activities)<-c("activity_numbers","activity")
names(extract_set)[2]<-"activity_numbers"
extract_set<-merge(x=activities,y=extract_set,by="activity_numbers",all.y=TRUE)
#clean up feature names and add them as column names
extract$V4<-gsub("\\(\\)","",extract$V2)
extract$V4<-gsub("\\(","_",extract$V4)
extract$V4<-gsub("\\)","_",extract$V4)
extract$V4<-gsub("-","_",extract$V4)
colnames(extract_set)=append(c("activity_id","activity","person_id"),extract$V4) 
#Download package reshape2 if needed.  Install it.
if (!require(reshape2)){
        install.packages("reshape2")
} 
library(reshape2)
melted_extract<-melt(extract_set,id.vars=c("activity_id","activity","person_id"))
report<-dcast(melted_extract,activity+person_id~variable,mean)
setwd("~/Documents")
write.csv(report,file="tidy_data.csv")
