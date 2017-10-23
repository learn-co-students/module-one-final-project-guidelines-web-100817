class MakeHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :title
    end
  end
end