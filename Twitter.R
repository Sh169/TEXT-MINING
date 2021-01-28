install.packages(c("twitteR","ROAuth","base64enc","httpuv","tm","SnowballC","wordcloud","RColorBrewer"))
library(twitteR)
library(ROAuth)
library(base64enc)
library(httpuv)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

api_key<-'0YbrkXRO0kHhPUKS7KU1lvkGj'
api_secret_key<-'g2E0pXI8LJJHRWBjjO0e7HCmIgzZGbZ1sslPiQ7BNvTCLtX1n6'
access_token<-'1346878455552507904-PVcXNXqk1N6o9SEXz6NFHvmycvdHrD'
access_token_secret<-'gW3IuM4Vxy6ivIVMpu5soMbdkty4U8zPbD0fadsLBa0Xe'
                        


setup_twitter_oauth(api_key,api_secret_key,access_token,access_token_secret)
tweets<-searchTwitter("Trump",n=500)

n.tweets<-length(tweets)
n.tweets
tweets.df<-twListToDF(tweets)
View(tweets.df)
