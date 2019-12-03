ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

# Type `rake -T` on your command line to see the available rake tasks.
#

task :console do

    abraham = User.find_by(name: "Abraham Rudy")
    alona = User.find_by(name: "Alona Yeheskel")
    brandon = User.find_by(name: "Brandon Harris")
    brian = User.find_by(name: "Brian Boisvert")
    cory = User.find_by(name: "Cory Baker")

    collection = abraham.collections.all[0]
    collection1 = abraham.collections.all[1]
    collection2 = alona.collections.all[0]
    collection3 = brandon.collections.all[0]
    collection4 = cory.collections.all[0]

    candle = Piece.all[0]
    potato = Piece.all[1]
    tomato = Piece.all[2]
    baker = Piece.all[3]
    butcher = Piece.all[4]

    binding.pry

end
