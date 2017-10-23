def greet
  puts "\nHello there! Welcome to our friendly Twitter CLI. All your base are belong to us."
  print "Please enter your username: "
  gets.chomp
end

def populate_database(username)
  puts "Populating the database with your so-called friends..."
  TwitterApi.get_user_friends(username)
  TwitterApi.get_user_tweets
  puts "\nAlright. We got some information for 'ya."
end

def get_user_input
  print "What would you like to do? (h for help, q for quit): "
  gets.chomp.downcase
end

def goodbye
  puts "Goodbye!"
  User.delete_all
  Tweet.delete_all
  Hashtag.delete_all
  TweetHashtag.delete_all
end