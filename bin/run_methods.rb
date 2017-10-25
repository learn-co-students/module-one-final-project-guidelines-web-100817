input = nil

def greet
  puts "\nHello there! Welcome to our friendly Twitter CLI.".colorize(:yellow)
  taste_the_rainbow("All your base are belong to us")
end

def keep_database?
  print "Would you like to keep the database or get a new one? "
  answer = gets.chomp
  populate_database if answer == "get"
end

def populate_database
  print "Please enter your username: "
  username = gets.chomp
  puts "Populating the database with your so-called friends...\n\n"
  User.delete_all
  Tweet.delete_all
  Hashtag.delete_all
  TweetHashtag.delete_all
  progress = ProgressBar.create(starting_at: 0, total: nil, length: 50)
  TwitterApi.get_my_tweets(username)
  TwitterApi.get_user_friends(username, progress)
  TwitterApi.get_user_tweets(progress)
  Sentiment.populate_sentiment_scores(progress)
  puts "\n\nAlright. We got some information for 'ya.".light_green
end

def get_user_input
  print "What would you like to do? (type 'h' for help, 'q' for quit): ".light_blue
  answer = gets.chomp
  if answer.match(/h[a|e]+lp|^h\b/)
    "help"
  elsif answer.match(/quit|^q\b|exit/)
    "quit"
  ### BASICS ###
  elsif answer.match(/((how many)|(number of)).*friends/)
    "number of friends"
  elsif answer.match(/((how many)|(number of)).*tweets/)
    "number of tweets"
  elsif answer.match(/((how many)|(number of)).*hashtags/)
    "number of hashtags"
  elsif answer.match(/(detail).+for (.+)/)
    $input = answer.match(/(detail).+for (.+)/).captures[1]
    "get details for user"
  ### ABOUT ME ###
  elsif answer.match(/my most ((popular)|(followed)) ((friend)|(person)|(account))/) && !answer.match(/\d/)
    "my most popular friend"
  elsif (answer.match(/my most ((popular)|(liked)) tweet/) || answer.match(/my.*tweet.*most.*like/)) && !answer.match(/\d/)
    "my most popular tweet"
  elsif answer.match(/my most ((popular)|(common)(ly)?( used)?) hashtag/) && !answer.match(/\d/)
    "my most popular hashtag"
  ### POPULARITY ###
  elsif (answer.match(/most ((popular)|(followed)) ((friend)|(person)|(account))/) || answer.match(/((friend)|(person)|(account)).*((most)|(highest number)).*((popular)|(followers))/)) && !answer.match(/\d/)
    "most popular friend"
  elsif answer.match(/most ((popular)|(common)(ly)?( used)?) hashtag/) && !answer.match(/\d/)
    "most popular hashtag"
  elsif (answer.match(/most ((popular)|(liked)) tweet/) || answer.match(/tweet.*most.*like/)) && !answer.match(/\d/)
    "most popular tweet"
  ### RELATIONS ##

  else
    answer
  end
end

def help
  puts "\nHere's a list of available commands:\n".green
  puts "- Basics".yellow
  puts "  - number of friends".cyan
  puts "  - number of tweets".cyan
  puts "  - number of hashtags".cyan
  puts "  - get details for user".cyan
  puts "- About Me".yellow
  puts "  - my sentiment score".cyan
  puts "  - my most positive/negative tweet".cyan
  puts "  - my most popular tweet".cyan
  puts "- Popularity".yellow
  puts "  - most popular friend".cyan
  puts "  - most popular hashtag".cyan
  puts "  - most popular tweet".cyan
  puts "- Relations".yellow
  puts "  - all user tweets".cyan
  puts "  - all user hashtags".cyan
  puts "  - all hashtag users".cyan
  puts "  - all hashtag tweets".cyan
  puts "  - user's top tweets".cyan
  puts "  - user's top hashtags".cyan
  puts "  - hashtag's top tweets".cyan
  puts "  - hashtag's top tweeters".cyan
  puts "- Sentiment".yellow
  puts "  - friend table".cyan
  puts "  - hashtag table".cyan
  puts "  - most positive/negative friend".cyan
  puts "  - most positive/negative tweet".cyan
  puts "  - most positive/negative hashtag".cyan
  puts "  - average friend sentiment".cyan
  puts "- Top 10s".yellow
  puts "  - top 10 most popular friends".cyan
  puts "  - top 10 most popular tweets".cyan
  puts "  - top 10 most popular hashtags\n".cyan
  puts "- All Info".yellow
  puts "  - all user info"
  puts "  - all hashtag info"
end

def err
  puts "\nInvalid input. Please try again.\n\n"
end

def goodbye
  puts "\nGoodbye!\n\n"
end

### HELPERS ###
def taste_the_rainbow(string)
  colors = [:light_magenta, :light_red, :light_yellow, :light_green, :light_cyan, :light_blue]
  color_index = 0
  string.split("").each.with_index do |letter, index|
    if index != string.length - 1
      print letter.colorize(colors[color_index])
      color_index < 5 ? color_index += 1 : color_index = 0
    else
      puts letter.colorize(colors[color_index])
    end
  end
end

def number_readability(number)
  number.to_s.reverse.scan(/.{1,3}/).join(",").reverse
end

def find_user(input)
  input.start_with?("@") ? User.find_by(twitter_handle: input.split("")[1..-1].join("")) : User.find_by(name: input)
end

def find_hashtag(input)
  input.start_with?("#") ? Hashtag.find_by(title: input.split("")[1..-1].join("")) : Hashtag.find_by(title: input)
end

def format_tweet(user, tweet)
  puts "\n#{user.name}" + " @#{user.twitter_handle}".yellow
  puts "#{tweet.date_posted.strftime("%A, %b %d %Y")} #{tweet.date_posted.strftime("%I:%M")}"
  puts "\n#{tweet.content}\n"
  puts "#{tweet.likes} \u{2764}\n\n"
end
