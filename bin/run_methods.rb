def greet
  puts "\nHello there! Welcome to our friendly Twitter CLI. All your base are belong to us."
  print "Please enter your username: "
  gets.chomp
end

def populate_database(username)
  puts "Populating the database with your so-called friends...\n\n"
  TwitterApi.get_user_friends(username)
  TwitterApi.get_user_tweets
  # Sentiment.populate_sentiment_scores
  puts "Alright. We got some information for 'ya."
end

def get_user_input
  print "What would you like to do? (h for help, q for quit): "
  gets.chomp.downcase
end

def help
  puts "\nHere's a list of available commands:\n\n"
  puts "- Basics"
  puts "  - number of friends"
  puts "  - number of tweets"
  puts "  - number of hashtags"
  puts "- Popularity"
  puts "  - most popular friend"
  puts "  - most popular hashtag"
  puts "  - most popular tweet"
  puts "- Sentiment"
  puts "  - friend table"
  puts "  - most positive/negative friend"
  puts "  - most positive/negative tweet"
  puts "  - most positive/negative hashtag"
  puts "  - average friend sentiment\n\n"
end

### BASICS ###
def number_of_friends
  puts "\nYou have #{User.all.count} friends. Not so bad. Could be better. You should get out more.\n\n"
end

def number_of_tweets
  puts "\nYour friends have tweeted #{Tweet.all.count} times. Like... whoa.\n\n"
end

def number_of_hashtags
  puts "\nYour friends have used #{Hashtag.all.count} hashtags a total of #{TweetHashtag.all.count} times. #octothorpe\n\n"
end

### POPULARITY ###
def most_popular_friend
  most_popular_friend = User.order("followers DESC").first
  puts "\nThe most popular person you follow is #{most_popular_friend.name}."
  puts "They have #{most_popular_friend.followers} followers. Wowza!\n\n"
end

def most_popular_tweet
  most_popular_tweet = Tweet.order("likes DESC").first
  puts "\nThe most popular tweet made by the people you follow was this one by #{most_popular_tweet.user.name}:"
  puts "#{most_popular_tweet.content}"
  puts "It has #{most_popular_tweet.likes} likes and #{most_popular_tweet.retweets} retweets. Good stuff.\n\n"
end

def most_popular_hashtag
  most_popular_hashtag = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").first
  tweeters = {}
  most_popular_hashtag.users.each {|tweeter| tweeters[tweeter.name] ? tweeters[tweeter.name] += 1 : tweeters[tweeter.name] = 1}
  puts "\nThe most popular hashtag among your friends is \##{most_popular_hashtag.title}"
  puts "It has been tweeted about #{most_popular_hashtag.tweets.count} times."
  puts "The person who has tweeted it most is #{tweeters.key(tweeters.values.max)}. They have tweeted it #{tweeters.values.max} times.\n\n"
end

def err
  puts "\nInvalid input. Please try again.\n\n"
end

def goodbye
  puts "\nGoodbye!\n\n"
  User.delete_all
  Tweet.delete_all
  Hashtag.delete_all
  TweetHashtag.delete_all
end