class MakeHashtags < ActiveRecord::Migration[4.2]
  def change
    create_table :hashtags do |t|
      t.string :title
    end
  end
end