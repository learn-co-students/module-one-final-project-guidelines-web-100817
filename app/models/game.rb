class Game < ActiveRecord::Base
  has_many :questions
  belongs_to :users
  has_one :score
end
