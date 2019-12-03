class CreateGames < ActiveRecord::Migration[4.2]
  def change
    create_table :games do |t|
      t.belongs_to :user
    end
  end
end
