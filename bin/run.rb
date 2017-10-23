require_relative '../config/environment'
require_relative './run_methods.rb'

username = greet
populate_database(username)
answer = nil
while answer != "q"
  case answer = get_user_input
  when "h"
    help
  end
end
goodbye