class Category < ActiveRecord::Base
  has_many :questions
  has_many :values, through: :questions
end
