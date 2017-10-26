class AddArtistColumn < ActiveRecord::Migration[4.2]
  def change
    add_column :artists, :artist_uniq_id, :string 
  end
end
