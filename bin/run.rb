
require_relative 'CLI.rb'

  Menu_1 = ["Personal Collections","Search Gallery","Exit"]
  Menu_2 = ["Open Collection","Create Collection","Go Back"]
  Menu_3 = ["Rename Collection","Delete Collection","Show Pieces","Search for Pieces","Go Back"]
 welcome
 user = get_user
 if user.has_collection == true
   puts "Welcome Back, #{user.name}!"
 else
   puts "Thanks for signing up, #{user.name}!"
   create_collection(user)
  end
  menu_1(user)
