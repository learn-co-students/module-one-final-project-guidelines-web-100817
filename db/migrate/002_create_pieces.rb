# name of piece
# url of piece
# img url of piece
# artist_name
# genes
# collection
class CreatePieces < ActiveRecord::Migration[4.2]
  def change
    create_table :pieces do |t|
      t.string :name
      t.string :url
      t.string :img_url
      t.string :artist_name
    end
  end
end
