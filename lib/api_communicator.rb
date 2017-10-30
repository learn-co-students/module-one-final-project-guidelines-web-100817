require 'rest-client'
require 'json'
require 'pry'


def get_all_recipes #parses all the data from JSON into array of hashes
  n = 1
  recipe_array = []
  100.times do
    all_recipes = RestClient.get("http://www.recipepuppy.com/api/?i=&q=&p=#{n}")
    recipe_hash = JSON.parse(all_recipes)
    recipe_array << recipe_hash["results"]
    n += 1
  end
  recipe_array = recipe_array.flatten
end
