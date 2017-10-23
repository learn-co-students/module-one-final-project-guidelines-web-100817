class User < ActiveRecord::Base
  has_many :tweets
  has_many :tweet_hashtags, through: :tweets
  has_many :hashtags, through: :tweet_hashtags
end