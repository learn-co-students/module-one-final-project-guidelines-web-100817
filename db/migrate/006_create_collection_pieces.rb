class CreateCollectionPieces < ActiveRecord::Migration[4.2]
  def change
    create_table :collection_pieces do |t|
      t.integer :collection_id
      t.integer :piece_id
    end
  end
end
