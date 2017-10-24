class MakeTweets < ActiveRecord::Migration[4.2]
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.string :content
      t.integer :retweets
      t.integer :likes
    end
  end
end