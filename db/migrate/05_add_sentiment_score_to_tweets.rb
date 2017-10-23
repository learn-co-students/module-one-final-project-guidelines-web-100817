class AddSentimentScoreToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :sentiment_score, :decimal
  end
end