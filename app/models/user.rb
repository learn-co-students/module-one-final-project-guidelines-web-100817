class User < ActiveRecord::Base
  has_many :tweets
  has_many :tweet_hashtags, through: :tweets
  has_many :hashtags, through: :tweet_hashtags

  def most_positive_tweet
    tweet = Tweet.where("user_id = ?", self.id).order("sentiment_score DESC").first
    "#{self.name}\'s most positive tweet is: #{tweet.content}"
  end

  def most_negative_tweet
    tweet = Tweet.where("user_id = ?", self.id).order("sentiment_score ASC").first
    "#{self.name}\'s most negative tweet is: #{tweet.content}"
  end

end
