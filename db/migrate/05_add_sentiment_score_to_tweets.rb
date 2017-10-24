class AddSentimentScoreToTweets < ActiveRecord::Migration[4.2]
  def change
    add_column :tweets, :sentiment_score, :decimal
  end
end