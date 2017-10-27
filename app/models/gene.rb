class Gene < ActiveRecord::Base
  has_many :pieces
  has_many :collections, through: :pieces
end
