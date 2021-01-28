install.packages(c("twitteR","ROAuth","base64enc","httpuv","tm","SnowballC","wordcloud","RColorBrewer"))
install.packages("syuzhet")
library(twitteR)
library(ROAuth)
library(base64enc)
library(httpuv)
library(tm) #text mining
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(syuzhet)

api_key<-'0YbrkXRO0kHhPUKS7KU1lvkGj'
api_secret_key<-'g2E0pXI8LJJHRWBjjO0e7HCmIgzZGbZ1sslPiQ7BNvTCLtX1n6'
access_token<-'1346878455552507904-PVcXNXqk1N6o9SEXz6NFHvmycvdHrD'
access_token_secret<-'gW3IuM4Vxy6ivIVMpu5soMbdkty4U8zPbD0fadsLBa0Xe'
                        


setup_twitter_oauth(api_key,api_secret_key,access_token,access_token_secret)
tweets<-searchTwitter("#education",n=20000,lang = 'en')

#Count the number of tweets
n.tweets<-length(tweets)
n.tweets

#converts tweets into df
tweets.df<-twListToDF(tweets)
View(tweets.df)

#start cleaning the data
mycorpus<- Corpus((VectorSource(tweets.df$text)))
mycorpus<-tm_map(mycorpus,removeWords,stopwords())

remove_url<-function(x) gsub("http[^[:space:]]*", "",x)
mycorpus <-tm_map(mycorpus,content_transformer(remove_url))

#remove anything other than  english letters and space
removeNumPunct <-function(x) gsub("[^[:alpha:][:space:]]*","",x)
mycorpus<-tm_map(mycorpus,content_transformer(removeNumPunct))
mycorpus<-tm_map(mycorpus,removeNumPunct)
mycorpus<-tm_map(mycorpus, content_transformer(tolower))
mycorpus<-tm_map(mycorpus,stripWhitespace)
mycorpus<-tm_map(mycorpus,stemDocument)

dtm<-DocumentTermMatrix(mycorpus)
options(warn=-1)
#create wordcloud

m<-as.matrix(dtm)
v<-sort(rowSums(m),decreasing=TRUE)
d<-data.frame(word=names(v),freq=v)
head(d,10)





#Getting sentiments 
# Emotions for each tweet using NRC dictionary
emotions <- get_nrc_sentiment(tweets.df$text)
emo_bar = colSums(emotions)
emo_sum = data.frame(count=emo_bar, emotion=names(emo_bar))
emo_sum$emotion = factor(emo_sum$emotion, levels=emo_sum$emotion[order(emo_sum$count, decreasing = TRUE)])


# Visualize the emotions from NRC sentiments
install.packages("plotly")
library(plotly)
p <- plot_ly(emo_sum, x=~emotion, y=~count, type="bar", color=~emotion) %>%
  layout(xaxis=list(title=""), showlegend=FALSE,
         title="Emotion Type for hashtag: #education")

p

#wordcloud
wordcloud(mycorpus,scale=c(2.5,0.4),width=2400,height=1800,
          rot.per=0.4,min.freq = 2,random.order = FALSE,
          colors = brewer.pal(6,"Dark2"))

