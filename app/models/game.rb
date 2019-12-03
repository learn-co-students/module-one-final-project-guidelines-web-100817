class Game < ActiveRecord::Base
  has_many :questions
  belongs_to :user
  has_one :score
end
