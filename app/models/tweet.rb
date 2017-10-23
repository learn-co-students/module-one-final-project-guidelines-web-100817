class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :tweet_hashtags
  has_many :hashtags, through: :tweet_hashtags
end