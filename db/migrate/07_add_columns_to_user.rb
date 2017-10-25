class AddColumnsToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :description, :string
    add_column :users, :tweet_count, :integer
  end
end
