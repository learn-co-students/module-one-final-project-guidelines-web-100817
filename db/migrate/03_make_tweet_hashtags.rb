class MakeTweetHashtags < ActiveRecord::Migration
  def change
    create_table :tweet_hashtags do |t|
      t.integer :tweet_id
      t.integer :hashtag_id
    end
  end
end