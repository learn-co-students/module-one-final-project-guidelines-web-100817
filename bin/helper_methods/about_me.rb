### ABOUT ME ###
def my_details
  puts "\nHere's everything there is to know about you:"
  puts "\n#{"name:".cyan} #{User.first.name}"
  puts "#{"username:".cyan} @#{User.first.twitter_handle}"
  puts "#{"description:".cyan} #{User.first.description}" 
  puts "#{"location:".cyan} #{User.first.location}"
  puts "#{"# of tweets:".cyan} #{number_readability(User.first.tweet_count)}"
  puts "#{"# following:".cyan} #{number_readability(User.first.following)}"
  puts "#{"# of followers:".cyan} #{number_readability(User.first.followers)}\n\n"
  print "Would you like to view your profile in the browser? "
  answer = gets.chomp
  if answer.match(/(?:[Yy]$)|(?:[Yy]es)|(?:[Ss]ure)/)
    twitter_url = "https://twitter.com/#{User.first.twitter_handle}"
    `open #{twitter_url}`
    print "\nThere you go. "
  else
    print "\nSuit yourself. "
  end
end

def my_tweets
  puts "\nHere are your tweets: \n\n"
  User.first.tweets.order("tweets.date_posted DESC").each do |tweet|
    format_tweet(User.first, tweet)
  end
end

def my_sentiment_score
  sentiment = Sentiment.get_avg_for_user(User.first)
  puts "\nYour sentiment score is currently: #{sentiment.to_s.light_green}"
  if sentiment < -0.5
    sentiment = "dreadful"
  elsif sentiment < 0
    sentiment = "a downer"
  elsif sentiment < 0.5
    sentiment = "slightly happy"
  else
    sentiment = "beaming"
  end
  puts "That means that you've probably been #{sentiment} lately.\n\n"
end

def my_most_popular_tweet
  user = User.first
  tweet = user.tweets.order("likes DESC").first
  puts "\nWow, a lot of people like this tweet! #{number_readability(tweet.likes).light_green} people, to be exact."
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
    puts "\nWow, looks you only wait an average of #{avg.to_s.light_green} hours between tweets. Needy much?\n\n"
  elsif avg < 24
    puts "\nYou tweet, on average, once every #{avg.to_s.light_green} hours.\n\n"
  else
    puts "\nYou only tweet once every #{avg.to_s.light_green} hours. You should probably tweet more if you want people to care.\n\n"
  end
end

  def my_most_common_hashtag
    user = User.first
    hashtag = Hashtag.joins(:tweets).where("tweets.user_id = ?", user.id).group("hashtags.title").order("count(hashtags.title) DESC").first
    puts "\nYour most used hashtag is #{"#".light_green}#{hashtag.title.light_green}. You've tweeted about it #{user.tweet_hashtags.where("hashtag_id = ?", hashtag.id).count.to_s.light_green} times.\n\n"
  end
