newData <- read.csv(file="./input.csv",header=TRUE,nrows = 1000000)
tags<-c(".net","css","c","mysql","xml","database","linux","php","c#","html","java","c++","python","sql-sever","javascript","asp.net",".net","actionscript-3air","ajax","algorithm","application","asm","asp","","asp.net","bash","c","c#","c++","css","csv","eclipse","facebook","firefox","flash","flex","font","
git","gui","gwt","html","http","iphone","j#","java","javascript","jquery","linux","lisp","mac","microsoft","mobile","mono","ms","mssql","mysql","perl","php","postgresql","powershell","python","rational","recursion","regex","rss","ruby","sap","security","shell","sql","sqlquery","sqlserver","sslstackoverflow","statistics","string","subversion","svn","ubuntu","unix","vb.net","vbscript","vim","visualbasic","visual-studio","vmware","web","xampp","xhtml")
#newData$Tag2[is.na(newData$Tag2)] <- newData$Tag3[is.na(newData$Tag2)]
newData<-newData[newData$Tag1 %in% tags ,]
#newData<-newData[newData$Tag2 %in% tags ,]
cols.dont.want = c("PostCreationDate","OwnerCreationDate","Tag3","Tag4","Tag5","PostClosedDate","OpenStatus")
newData<- newData[, ! names(newData) %in% cols.dont.want, drop = F]
gsub("[\r\n]", "", newData$Title) 
gsub("[\r\n]", "", newData$BodyMarkdown) 
write.csv(newData, file = "./processed.csv")
