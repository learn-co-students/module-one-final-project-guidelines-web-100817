### ABOUT ME ###
def my_sentiment
  sentiment = Sentiment.get_avg_for_user(User.first)
  puts "\nYour sentiment score is currently: #{sentiment}"
  if sentiment < -0.5
    sentiment = "dreadful"
  elsif sentiment < 0
    sentiment = "downer"
  elsif sentiment < 0.5
    sentiment = "slightly happy"
  else
    sentiment = "beaming"
  end
  puts "That means that you've probably been #{sentiment} lately."
end

def my_most_popular_tweet
  user = User.first
  tweet = user.tweets.order("likes DESC").first
  puts "\nWow, a lot of people like this tweet! #{number_readability(tweet.likes)} people, to be exact."
  format_tweet(user, tweet)
end

def my_most_positive_tweet
  tweet = User.first.tweets.order("sentiment_score DESC").first
  puts "\nDid you meet a tiny duck in boots just before you tweeted this?"
  format_tweet(User.first, tweet)
end

def my_most_negative_tweet
  tweet = User.first.tweets.order("sentiment_score ASC").first
  puts "\nGeez, you didn't have to kick over my half-full glass."
  format_tweet(User.first, tweet)
end

def my_average_tweeting_time
  user = User.first
  time1 = user.tweets.last.date_posted
  time2 = user.tweets.first.date_posted
  avg = (((time2 - time1) / 1.hour).round) / user.tweets.length
  if avg < 10
    puts "\nWow, looks you only wait an average of #{avg} hours between tweets. Needy much?"
  elsif avg < 24
    puts "\nYou tweet, on average, once every #{avg} hours."
  else
    puts "\nYou only tweet once every #{avg} hours. You should probably tweet more if you want people to care."
  end
end
