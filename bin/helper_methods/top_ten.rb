### TOP 10 ###
def top_ten_most_popular_friends
  users = User.order("users.followers DESC").take(10)
  rows = users.inject([]) do |memo, user|
    memo << [user.name, user.twitter_handle, number_readability(user.followers)]
    memo
  end
  table = Terminal::Table.new(:headings => ["Name".yellow, "Twitter Handle".yellow, "Followers".yellow], :rows => rows)
  puts table
end

def top_ten_most_popular_tweets
  tweets = Tweet.order("likes DESC").take(10)
  puts "\n\n"
  tweets.each do |tweet|
    user = User.find(tweet.user_id)
    format_tweet(user, tweet)
  end
end

def top_ten_most_popular_hashtags
  hashtags = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").take(10)
  rows = hashtags.inject([]) do |memo, hashtag|
    memo << ["\##{hashtag.title}", hashtag.tweets.count]
  end
  table = Terminal::Table.new(:headings => ["Hashtag".yellow, "\# of Tweets".yellow], :rows => rows)
  puts table
end

def top_ten_tweeters
  users = User.order("tweet_count DESC").take(10)
  rows = users.inject([]) do |memo, user|
    memo << [user.name, user.twitter_handle, user.tweet_count]
  end
  table = Terminal::Table.new(:headings => ["Name".yellow, "Twitter Handle".yellow, "# of Tweets".yellow], :rows => rows)
  puts table
end
