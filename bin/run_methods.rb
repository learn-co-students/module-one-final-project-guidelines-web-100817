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
  puts "- Popularity".yellow
  puts "  - most popular friend".cyan
  puts "  - most popular hashtag".cyan
  puts "  - most popular tweet".cyan
  puts "- Sentiment".yellow
  puts "  - friend table".cyan
  puts "  - most positive/negative friend".cyan
  puts "  - most positive/negative tweet".cyan
  puts "  - most positive/negative hashtag".cyan
  puts "  - average friend sentiment\n".cyan
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
  Sentiment.sentiment_table
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
#
# def number_readability(number)
#   num_array = number.to_s.split("")
#   return_array = []
#   num_array.each.with_index do |int, index|
#     nums_left = num_array.length - index
#     if nums_left % 3 == 0 && nums_left > 0
#       return_array << ",#{int}"
#     else
#       return_array << int
#     end
#   end
#   return_array.join("")
# end
def number_readability(number)
  number.reverse.scan(/.{1,3}/).join(",").reverse
end
