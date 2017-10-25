class Question < ActiveRecord::Base
  belongs_to :category
  belongs_to :value
  belongs_to :game
end
