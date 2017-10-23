class MakeUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :twitter_handle
      t.string :location
      t.integer :following
      t.integer :followers
    end
  end
end