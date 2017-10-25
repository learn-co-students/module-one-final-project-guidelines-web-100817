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
