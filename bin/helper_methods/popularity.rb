### POPULARITY ###
def most_popular_friend
  most_popular_friend = User.order("followers DESC").first
  puts "\nThe most popular person you follow is #{most_popular_friend.name}."
  print "They have "
  print "#{number_readability(most_popular_friend.followers)} ".light_green
  puts "followers. Wowza!\n\n"
end

def most_popular_tweet
  most_popular_tweet = Tweet.order("likes DESC").first
  puts "\nHere's the most popular tweet made by the people in your network:"
  format_tweet(most_popular_tweet.user, most_popular_tweet)
end

def most_popular_hashtag
  most_popular_hashtag = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").first
  tweeters = {}
  most_popular_hashtag.users.each {|tweeter| tweeters[tweeter.name] ? tweeters[tweeter.name] += 1 : tweeters[tweeter.name] = 1}
  puts "\nThe most popular hashtag among your friends is #{"#".light_green}#{most_popular_hashtag.title.light_green}"
  puts "It has been tweeted about #{most_popular_hashtag.tweets.count.to_s.light_green} times."
  puts "The person who has tweeted it most is #{tweeters.key(tweeters.values.max).light_green}. They have tweeted it #{tweeters.values.max.to_s.light_green} times.\n\n"
end
