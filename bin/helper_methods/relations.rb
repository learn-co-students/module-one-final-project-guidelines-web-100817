### RELATIONS ###
def all_user_tweets(input)
  user = find_user(input)
  if user
    puts "\nHere are all the tweets from #{user.name.light_green}:\n\n"
    user.tweets.each do |tweet|
      format_tweet(user, tweet)
    end
  end
end

def all_user_hashtags(input)
  user = find_user(input)
  if user
    puts "\nHere are all the hashtags used by #{user.name.light_green}:\n\n"
    user.hashtags.each do |hashtag|
      puts "\##{hashtag.title}"
    end
    puts ""
  end
end

def all_hashtag_users(input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere are all the people who have tweeted about #{"#".light_green}#{hashtag.title.light_green}:\n\n"
    hashtag.users.uniq.each do |user|
      puts user.name
    end
    puts ""
  end
end

def all_hashtag_tweets(input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere are all the tweets about \##{hashtag.title.light_green}:\n\n"
    hashtag.tweets.each do |tweet|
      user = User.find(tweet.user_id)
      format_tweet(user, tweet)
    end
  end
end

def user_top_tweets(input)
  user = find_user(input)
  if user
    puts "\nHere are the top 5 tweets from #{user.name.light_green}:\n\n"
    user.tweets.order("tweets.likes DESC").limit(5).each do |tweet|
      format_tweet(user, tweet)
    end
  end
end

def user_top_hashtags(input)
  user = find_user(input)
  if user
    puts "\nHere are hashtags most commonly used by #{user.name.light_green}:\n\n"
    Hashtag.joins(:tweets).where("tweets.user_id = ?", user.id).group("hashtags.title").order("count(hashtags.title) DESC").each do |hashtag|
      puts "\##{hashtag.title}: #{Hashtag.joins(:tweets).where("hashtags.id = #{hashtag.id}").count}"
    end
    puts ""
  end
end

def hashtag_top_tweets(input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere are the 5 most popular tweets about \##{hashtag.title.light_green}:\n\n"
    hashtag.tweets.order("tweets.likes DESC").limit(5).each do |tweet|
      user = User.find(tweet.user_id)
      format_tweet(user, tweet)
    end
  end
end

def hashtag_top_users(input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere are the people who tweet the most about #{"#".light_green}#{hashtag.title.light_green}"
    User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = #{hashtag.id}").group("users.id").order("count(users.id) DESC").each do |user|
      puts "#{user.name}: #{user.tweet_hashtags.where(hashtag_id: hashtag.id).count}"
    end
    puts ""
  end
end

def hashtag_most_positive(input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere's the most positive tweet for #{hashtag.title}:"
    tweet = hashtag.tweets.order("sentiment_score DESC").first
    format_tweet(User.find(tweet.user_id), tweet)
  end
  puts ""
end

def hashtag_most_negative (input)
  hashtag = find_hashtag(input)
  if hashtag
    puts "\nHere's the most negative tweet for #{hashtag.title}:"
    tweet = hashtag.tweets.order("sentiment_score ASC").first
    format_tweet(User.find(tweet.user_id), tweet)
  end
  puts ""
end
