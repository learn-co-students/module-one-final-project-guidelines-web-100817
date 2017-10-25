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
  running = true
  while running
    print "What would you like to do? (type 'h' for help, 'q' for quit): ".light_blue
    answer = gets.chomp
    if answer.match(/h[a|e]+lp|^h\b/)
      help
    elsif answer.match(/quit|^q\b|exit/)
      goodbye
      running = false
      break
    ### BASICS ###
    elsif answer.match(/((how many)|(number of)).*friends/)
      number_of_friends
    elsif answer.match(/((how many)|(number of)).*tweets/)
      number_of_tweets
    elsif answer.match(/((how many)|(number of)).*hashtags/)
      number_of_hashtags
    elsif answer.match(/(detail).+for (.+)/)
      $input = answer.match(/(detail).+for (.+)/)
      get_details_for_user
    ### ABOUT ME ###
    elsif 
      my_sentiment_score
    elsif (answer.match(/my most ((popular)|(liked)) tweet/) || answer.match(/my.*tweet.*most.*like/)) && !answer.match(/\d/)
      my_most_popular_tweet
    elsif
      my_most_positive_tweet
    elsif
      my_most_negative_tweet
    elsif answer.match(/my most ((popular)|(common)(ly)?( used)?) hashtag/) && !answer.match(/\d/)
      my_most_common_hashtag
    ### POPULARITY ###
    elsif (answer.match(/most ((popular)|(followed)) ((friend)|(person)|(account))/) || answer.match(/((friend)|(person)|(account)).*((most)|(highest number)).*((popular)|(followers))/)) && !answer.match(/\d/)
      most_popular_friend
    elsif answer.match(/most ((popular)|(common)(ly)?( used)?) hashtag/) && !answer.match(/\d/)
      most_popular_hashtag
    elsif (answer.match(/most ((popular)|(liked)) tweet/) || answer.match(/tweet.*most.*like/)) && !answer.match(/\d/)
      most_popular_tweet
    ### RELATIONS ##
    elsif answer.match(/all (of )?(.+)'s tweets/) || answer.match(/all tweets (.*)((from)|(by)) (.*)/)
      $input = answer.match(/all (of )?(.+)'s tweets/) || answer.match(/all tweets (.*)((from)|(by)) (.*)/)
      all_user_tweets
    elsif answer.match(/all (of )?(.+)'s hashtags/) || answer.match(/all hashtags .*by (.*)/)
      $input = answer.match(/all (of )?(.+)'s hashtags/) || answer.match(/all hashtags .*by (.*)/)
      all_user_hashtags
    elsif answer.match(/(A|a)ll.*tweets.*#(.*)/) || answer.match(/((tweeting)|(saying)).*#(.*)/)
      $input = answer.match(/(A|a)ll.*tweets.*#(.*)/) || answer.match(/((tweeting)|(saying)).*#(.*)/)
      all_hashtag_tweets
    elsif answer.match(/(A|a)ll.*((users)|(people)|(accounts)).*((hashtag )|(#))(.*)/) || answer.match(/(E|e)veryone.*((about )|(#))(.*)/)
      $input = answer.match(/(A|a)ll.*((users)|(people)|(accounts)).*((hashtag )|(#))(.*)/) || answer.match(/(E|e)veryone.*((about )|(#))(.*)/)
      all_hashtag_users
    elsif
      user_top_tweets
    elsif
      user_top_hashtags
    elsif
      hashtag_top_tweets
    elsif
      hashtag_top_users
    ### SENTIMENT ###
    elsif
      friends_table
    elsif
      hashtags_table
    elsif
      most_positive_friend
    elsif
      most_negative_friend
    elsif
      most_positive_tweet
    elsif
      most_negative_tweet
    elsif
      most_positive_hashtag
    elsif
      most_negative_hashtag
    elsif
      average_friend_sentiment
    ### TOP 10s ###
    elsif
      top_ten_most_popular_friends
    elsif
      top_ten_most_popular_tweets
    elsif
      top_ten_most_popular_hashtags
    ### ALL INFO ###
    elsif
      all_user_info
    elsif
      all_hashtag_info
    else
      err
    end
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
  puts "  = my most common hashtag".cyan
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
  puts "  - hashtag's top users".cyan
  puts "- Sentiment".yellow
  puts "  - friends table".cyan
  puts "  - hashtags table".cyan
  puts "  - most positive/negative friend".cyan
  puts "  - most positive/negative tweet".cyan
  puts "  - most positive/negative hashtag".cyan
  puts "  - average friend sentiment".cyan
  puts "- Top 10s".yellow
  puts "  - top 10 most popular friends".cyan
  puts "  - top 10 most popular tweets".cyan
  puts "  - top 10 most popular hashtags".cyan
  puts "- All Info".yellow
  puts "  - all user info"
  puts "  - all hashtag info\n"
end

def err
  puts "\nInvalid input. Please try again.\n\n"
end

def goodbye
  puts "\nGoodbye!\n\n"
end
