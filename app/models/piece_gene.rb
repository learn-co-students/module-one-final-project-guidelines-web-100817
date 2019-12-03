class PieceGene < ActiveRecord::Base
  belongs_to :piece
  belongs_to :gene
end
