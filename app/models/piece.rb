class Piece < ActiveRecord::Base
    has_many :collection_pieces
    has_many :collections, through: :collections_pieces
    has_many :users, through: :collections
    has_many :piece_genes
    has_many :genes, through: :piece_genes


    # It prints out the picture from the url on the terminal
    # source has to be the full path.
  def print
    Catpix::print_image self.img_url,
      :limit_x => 1.0,
      :limit_y => 0,
      :center_x => true,
      :center_y => true,
      :bg => "white",
      :bg_fill => true,
      :resolution => "high"
    end

    def self.local_methods
      [:id,:name,:url,:img_url,:artist_name]
    end

end
