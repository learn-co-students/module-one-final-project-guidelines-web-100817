class CollectionPiece < ActiveRecord::Base
  belongs_to :collection
  belongs_to :piece
end
