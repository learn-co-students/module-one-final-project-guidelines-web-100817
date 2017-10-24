def greet
  puts "\nHello there! Welcome to our friendly Twitter CLI.".colorize(:yellow)
  taste_the_rainbow("All your base are belong to us")
end

def keep_database?
  print "Would you like to keep the database or get a new one? "
  answer = gets.chomp
  populate_database if answer == "get"
end

def populate_database
  print "Please enter your username: "
  username = gets.chomp
  puts "Populating the database with your so-called friends...\n\n"
  User.delete_all
  Tweet.delete_all
  Hashtag.delete_all
  TweetHashtag.delete_all
  progress = ProgressBar.create(starting_at: 0, total: nil, length: 50)
  TwitterApi.get_my_tweets(username)
  TwitterApi.get_user_friends(username, progress)
  TwitterApi.get_user_tweets(progress)
  Sentiment.populate_sentiment_scores(progress)
  puts "\n\nAlright. We got some information for 'ya.".light_green
end

def get_user_input
  print "What would you like to do? (type 'h' for help, 'q' for quit): ".light_blue
  gets.chomp.downcase
end

def help
  puts "\nHere's a list of available commands:\n".green
  puts "- Basics".yellow
  puts "  - number of friends".cyan
  puts "  - number of tweets".cyan
  puts "  - number of hashtags".cyan
  puts "- About Me".yellow
  puts "  - my sentiment score".cyan
  puts "  - my most positive/negative tweet".cyan
  puts "  - my most popular tweet".cyan
  puts "- Popularity".yellow
  puts "  - most popular friend".cyan
  puts "  - most popular hashtag".cyan
  puts "  - most popular tweet".cyan
  puts "- Sentiment".yellow
  puts "  - friend table".cyan
  puts "  - hashtag table".cyan
  puts "  - most positive/negative friend".cyan
  puts "  - most positive/negative tweet".cyan
  puts "  - most positive/negative hashtag".cyan
  puts "  - average friend sentiment\n".cyan
  puts "- Top 10s".yellow
  puts "  - top 10 most popular friends".cyan
  puts "  - top 10 most popular tweets".cyan
  puts "  - top 10 most popular hashtags".cyan
end

def err
  puts "\nInvalid input. Please try again.\n\n"
end

def goodbye
  puts "\nGoodbye!\n\n"
end

### BASICS ###
def number_of_friends
  puts "\nYou have #{User.all.count} friends. Not so bad. Could be better. You should get out more.\n\n"
end

def number_of_tweets
  puts "\nYour friends have tweeted #{Tweet.all.count} times. Like... whoa.\n\n"
end

def number_of_hashtags
  print "\nYour friends have used #{Hashtag.all.count} hashtags a total of #{TweetHashtag.all.count} times. "
  taste_the_rainbow("#octothorpe")
  puts ""
end

### ABOUT ME ###
def my_sentiment
  Sentiment.get_avg_for_user(User.last)
end

def my_most_popular_tweet
  user = User.last
  tweet = user.tweets.order("likes DESC").first
  puts "\nWow, a lot of people like this tweet! #{number_readability(tweet.likes)} people, to be exact."
  format_tweet(user, tweet)
end

def my_most_positive_tweet
  tweet = User.last.tweets.order("sentiment_score DESC").first
  puts "\nDid you meet a tiny duck in boots just before you tweeted this?"
  format_tweet(User.last, tweet)
end

def my_most_negative_tweet
  tweet = User.last.tweets.order("sentiment_score ASC").first
  puts "\nGeez, you didn't have to kick over my half-full glass."
  format_tweet(User.last, tweet)
end

### POPULARITY ###
def most_popular_friend
  most_popular_friend = User.order("followers DESC").first
  puts "\nThe most popular person you follow is #{most_popular_friend.name}."
  print "They have "
  print "#{number_readability(most_popular_friend.followers)} ".light_red
  puts "followers. Wowza!\n\n"
end

def most_popular_tweet
  most_popular_tweet = Tweet.order("likes DESC").first
  puts "\nThe most popular tweet made by the people you follow was this one by #{most_popular_tweet.user.name}:"
  puts "#{most_popular_tweet.content}".yellow
  puts "It has #{number_readability(most_popular_tweet.likes).light_red} likes and #{number_readability(most_popular_tweet.retweets).light_red} retweets. Good stuff.\n\n"
end

def most_popular_hashtag
  most_popular_hashtag = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").first
  tweeters = {}
  most_popular_hashtag.users.each {|tweeter| tweeters[tweeter.name] ? tweeters[tweeter.name] += 1 : tweeters[tweeter.name] = 1}
  puts "\nThe most popular hashtag among your friends is \##{most_popular_hashtag.title}"
  puts "It has been tweeted about #{most_popular_hashtag.tweets.count} times."
  puts "The person who has tweeted it most is #{tweeters.key(tweeters.values.max)}. They have tweeted it #{tweeters.values.max} times.\n\n"
end

### SENTIMENT ###
def friend_table
  puts "\nHere's a table of how positive or negative your friends are:"
  Sentiment.table(Sentiment.user_sentiment_hash)
  puts "\n\n"
end

def hashtag_table
  puts "\nHere's a table of how positive or negative all the hashtags are:"
  Sentiment.table(Sentiment.avg_hashtag_hash)
  puts "\n\n"
end

def most_positive_friend
  puts "\nLooks like #{Sentiment.most_positive_friend} is a real ray of sunshine.\n\n"
end

def most_negative_friend
  puts "\nIs it true that #{Sentiment.most_negative_friend} is always a bummer?\n\n"
end

def most_positive_tweet
  puts "\nDoes this make you happy?"
  puts "#{Sentiment.most_positive_tweet}\n\n"
end

def most_negative_tweet
  puts "\nBack in MY day, we walked uphill everywhere we went."
  puts "#{Sentiment.most_negative_tweet}\n\n"
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

### TOP 10 ###
def top_ten_popular_friends
  users = User.order("users.followers DESC").take(10)
  rows = users.inject([]) do |memo, user|
    memo << [user.name, user.twitter_handle, number_readability(user.followers)]
    memo
  end
  table = Terminal::Table.new(:headings => ["Name".yellow, "Twitter Handle".yellow, "Followers".yellow], :rows => rows)
  puts table
end

def top_ten_popular_tweets
  tweets = Tweet.order("likes DESC").take(10)
  puts "\n\n"
  tweets.each do |tweet|
    user = User.find(tweet.user_id)
    format_tweet(user, tweet)
    puts "\n-------------------------------------------------\n\n"
    sleep(0.75)
  end
end

def top_ten_popular_hashtags
  hashtags = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").take(10)
  rows = hashtags.inject([]) do |memo, hashtag|
    memo << ["\##{hashtag.title}", hashtag.tweets.count]
  end
  table = Terminal::Table.new(:headings => ["Hashtag".yellow, "\# of Tweets".yellow], :rows => rows)
  puts table
end


### FORMATTING ###
def taste_the_rainbow(string)
  colors = [:light_magenta, :light_red, :light_yellow, :light_green, :light_cyan, :light_blue]
  color_index = 0
  string.split("").each.with_index do |letter, index|
    if index != string.length - 1
      print letter.colorize(colors[color_index])
      color_index < 5 ? color_index += 1 : color_index = 0
    else
      puts letter.colorize(colors[color_index])
    end
  end
end

def number_readability(number)
  number.to_s.reverse.scan(/.{1,3}/).join(",").reverse
end

def format_tweet(user, tweet)
  puts "\n#{user.name}" + " @#{user.twitter_handle}".yellow
  puts "#{tweet.date_posted.strftime("%A, %b %d %Y")} #{tweet.date_posted.strftime("%I:%M")}"
  puts "\n#{tweet.content}\n"
  puts "#{tweet.likes} \u{2764}\n\n"
end
