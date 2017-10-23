class TwitterApi

  keys = YAML.load_file('config/application.yml')
  @@client = Twitter::REST::Client.new do |config|
    config.consumer_key        = keys['consumer_key']
    config.consumer_secret     = keys['consumer_secret']
    config.access_token        = keys['access_token']
    config.access_token_secret = keys['access_token_secret']
  end

  def self.get_user_friends(username)
    friends_info = @@client.friends(username).attrs[:users]
    friends_info.each do |friend|
      User.create(name: friend[:name], twitter_handle: friend[:screen_name], location: friend[:location], following: friend[:friends_count], followers: friend[:followers_count])
    end
  end

  def self.get_user_tweets
    User.all.each do |user|
      user_tweets = @@client.user_timeline(user[:twitter_handle])
      user_tweets.each do |tweet|
        Tweet.create(user_id: user.id, content: tweet.text, retweets: tweet.retweet_count, likes: tweet.favorite_count)
        if !tweet.hashtags.empty?
          tweet.hashtags.each do |hashtag|
            TweetHashtag.create(tweet: Tweet.all.last, hashtag: Hashtag.find_or_create_by(title: hashtag.text))
          end
        end
      end
    end
  end
  
end