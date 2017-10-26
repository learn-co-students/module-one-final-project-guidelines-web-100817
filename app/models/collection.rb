# name_of_collection
class Collection < ActiveRecord::Base
  belongs_to :user
  has_many :collection_pieces
  has_many :pieces, through: :collection_pieces
end
