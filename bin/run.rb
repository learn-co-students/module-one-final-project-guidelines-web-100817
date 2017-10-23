require_relative '../config/environment'
require_relative './run_methods.rb'

username = greet
populate_database(username)
while get_user_input != "q"
  get_user_input
end
goodbye