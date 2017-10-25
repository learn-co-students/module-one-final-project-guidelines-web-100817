### RELATIONS ###
def all_user_tweets(input)
  user = find_user(input)
  puts "\nHere are all the tweets from #{user.name}:\n\n"
  user.tweets.each do |tweet|
    format_tweet(user, tweet)
  end
end

def all_user_hashtags(input)
  user = find_user(input)
  puts "\nHere are all the hashtags used by #{user.name}:\n\n"
  user.hashtags.each do |hashtag|
    puts "\##{hashtag.title}"
  end
end

def all_hashtag_users(input)
  hashtag = find_hashtag(input)
  puts "\nHere are all the people who have tweeted about \##{hashtag.title}:\n\n"
  hashtag.users.each do |user|
    puts user.name
  end
end

def all_hashtag_tweets(input)
  hashtag = find_hashtag(input)
  puts "\nHere are all the tweets about \##{hashtag.title}:\n\n"
  hashtag.tweets.each do |tweet|
    user = User.find(tweet.user_id)
    format_tweet(user, tweet)
  end
end

def user_top_tweets(input)
  user = find_user(input)
  puts "\nHere are the top 5 tweets from #{user.name}:\n\n"
  user.tweets.order("tweets.likes DESC").limit(5).each do |tweet|
    format_tweet(user, tweet)
  end
end

def user_top_hashtags(input)
  user = find_user(input)
  binding.pry
  puts "\nHere are hashtags most commonly used by #{user.name}:\n\n"
  Hashtag.joins(:tweets).where("tweets.user_id = ?", user.id).group("hashtags.title").order("count(hashtags.title) DESC").each do |hashtag|
    puts "\##{hashtag.title}: #{Hashtag.joins(:tweets).where("hashtags.id = #{hashtag.id}").count}"
  end
  puts ""
end

def hashtag_top_tweets(input)
  hashtag = find_hashtag(input)
  puts "\nHere are the most popular tweets about \##{hashtag.title}:\n\n"
  hashtag.tweets.order("tweets.likes DESC").each do |tweet|
    user = User.find(tweet.user_id)
    format_tweet(user, tweet)
  end
end

def hashtag_top_users(input)
  hashtag = find_hashtag(input)
  User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = 335").group("users.id").order("count(users.id) DESC").each do |user|
    puts "\##{user.name}: #{User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = #{hashtag.id}").count}"
  end
  puts ""
end
