class CreateArtistTrackTable < ActiveRecord::Migration[4.2]
  def change
    create_table :artist_tracks do |t|
      t.integer :artist_id
      t.integer :track_id 
    end
  end
end
