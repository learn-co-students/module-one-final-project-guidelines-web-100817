### SENTIMENT ###
def friends_table
  puts "\nHere's a table of how positive or negative your friends are:\n"
  Sentiment.table(Sentiment.user_sentiment_hash)
  puts "\n"
end

def hashtags_table
  puts "\nHere's a table of how positive or negative all the hashtags are:\n"
  Sentiment.table(Sentiment.avg_hashtag_hash)
  puts "\n"
end

def most_positive_friend
  puts "\nLooks like #{Sentiment.most_positive_friend.light_green} is a real ray of sunshine.\n\n"
end

def most_negative_friend
  puts "\nIs it true that #{Sentiment.most_negative_friend.red} is always a bummer?\n\n"
end

def most_positive_tweet
  puts "\nDoes this make you happy?"
  format_tweet(Sentiment.most_positive_tweet[0], Sentiment.most_positive_tweet[1])
end

def most_negative_tweet
  puts "\nBack in MY day, we walked uphill everywhere we went."
  format_tweet(Sentiment.most_negative_tweet[0], Sentiment.most_negative_tweet[1])
end

def average_friend_sentiment
  puts "\nThe average mood of the people you follow is:"
  sentiment = Sentiment.get_avg_sentiment
  puts sentiment
  if sentiment < -0.5
    sentiment = "dreadful"
  elsif sentiment < 0
    sentiment = "downer"
  elsif sentiment < 0.5
    sentiment = "slightly happy"
  else
    sentiment = "beaming"
  end
  puts "That means you're surrounded by #{sentiment} people."
end

def most_positive_hashtag
  hash = Sentiment.avg_hashtag_hash
  title = hash.find {|name, score| score == hash.values.max}[0]
  puts "\nIf you want to be cruel, you should tweet with \##{title}.\n\n"
end

def most_negative_hashtag
  hash = Sentiment.avg_hashtag_hash
  title = hash.find {|name, score| score == hash.values.min}[0]
  puts "\nTo wallow in your misery with other likeminded people, use \##{title}.\n\n"
end
