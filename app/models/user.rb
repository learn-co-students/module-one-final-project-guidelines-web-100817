# name
class User < ActiveRecord::Base
   has_many :collections, dependent: :destroy
   has_many :pieces, through: :collections
   has_many :genes, through: :pieces

  def has_collection
      !self.collections.empty?
    end

  def create_collection
    puts "Please enter the name of your collection"
    input = gets.chomp
    self.collections.create(:name => input)
  end

def add_pieces (collection,piece)
  user.collection.pieces << piece
end


end
