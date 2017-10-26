class CreateTracksTable < ActiveRecord::Migration[4.2]
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :available_markets
      t.integer :duration
      t.integer :popularity
      t.string :track_uniq_id
    end
  end
end
