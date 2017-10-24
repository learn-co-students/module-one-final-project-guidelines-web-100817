require 'rest-client'
require 'json'
require 'pry'



def iterator
  counter = 0
  newData = []


  #
  while counter < 100 do
    all_clues = RestClient.get('http://jservice.io/api/clues', {params:{offset: counter}}) #array 0 thru counter
    clues = JSON.parse(all_clues)
    newData << clues
    counter += 100
  end
  # binding.pry
  fullData = newData.flatten
  fullData.each do |obj|
    category = Category.find_or_create_by(name: obj["category"]["title"])
    value = Value.find_or_create_by(value: obj["value"])
    question = Question.find_or_create_by(question: obj["question"], answer: obj["answer"], category: category, value: value, date: obj["airdate"])
  end


end


# iterator


## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
