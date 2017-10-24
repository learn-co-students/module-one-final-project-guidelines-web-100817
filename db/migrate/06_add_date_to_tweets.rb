class AddDateToTweets < ActiveRecord::Migration[4.2]
  def change
    add_column :tweets, :date_posted, :datetime
  end
end
