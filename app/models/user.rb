class User < ActiveRecord::Base
  has_many :tweets
  has_many :tweet_hashtags, through: :tweets
  has_many :hashtags, through: :tweet_hashtags

  def most_positive_tweet
    Tweet.where("user_id = ?", self.id).order("sentiment_score DESC").first.content
  end

  def most_negative_tweet
    Tweet.where("user_id = ?", self.id).order("sentiment_score ASC").first.content
  end

end
