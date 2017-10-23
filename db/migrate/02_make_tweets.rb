class MakeTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :user_id
      t.string :content
      t.integer :comments
      t.integer :retweets
      t.integer :likes
    end
  end
end