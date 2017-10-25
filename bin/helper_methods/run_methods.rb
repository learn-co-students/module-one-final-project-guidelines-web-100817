def greet
  puts "\nHello there! Welcome to our friendly Twitter CLI.".colorize(:yellow)
  taste_the_rainbow("All your base are belong to us")
end

def keep_database?
  if !User.all.empty?
    puts "Would you like to keep the database or get a new one? "
    print "(The user inputted for the previous database was #{"@".light_green}#{User.first.twitter_handle.light_green}) "
    answer = gets.chomp
    if answer.include?("get") || answer.include?("new")
      populate_database
    else
      print "Awesome. ".light_blue
    end
  else
    populate_database
  end
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
  loop do
    print "What would you like to do? (type 'h' for help, 'q' for quit): ".light_blue
    answer = gets.chomp
    if
      answer.match(/h[a|e]+lp|^h\b/)
      help
    elsif
      answer.match(/quit|^q\b|exit/)
      goodbye
      break

    ### BASICS ###

    elsif
      answer.match(/((how many)|(number of)).*friends/)
      number_of_friends
    elsif
      answer.match(/((how many)|(number of)).*tweets/)
      number_of_tweets
    elsif
      answer.match(/((how many)|(number of)).*hashtags/)
      number_of_hashtags
    elsif
      answer.match(/(detail).+for (.+)/)
      input = answer.match(/(detail).+for (.+)/)
      get_details_for_user(input)

    ### ABOUT ME ###

    elsif
      answer.match(/my sentiment score/)
      my_sentiment_score
    elsif
      (answer.match(/my most ((popular)|(liked)) tweet/) || answer.match(/my.*tweet.*most.*like/)) && !answer.match(/\d/)
      my_most_popular_tweet
    elsif
      answer.match(/my.*most.*positive.*tweet/) || answer.match(/my.*tweet.*most.*positive/)
      my_most_positive_tweet
    elsif
      answer.match(/my.*most.*negative.*tweet/) ||
      answer.match(/my.*tweet.*most.*negative/)
      my_most_negative_tweet
    elsif
      answer.match(/my most ((popular)|(common)(ly)?( used)?) hashtag/) &&
      !answer.match(/\d/)
      my_most_popular_hashtag

    ### POPULARITY ###

    elsif
      (answer.match(/most ((popular)|(followed)) ((friend)|(person)|(account))/) ||
      answer.match(/((friend)|(person)|(account)).*((most)|(highest number)).*((popular)|(followers))/)) &&
      !answer.match(/\d/)
      most_popular_friend
    elsif
      answer.match(/most ((popular)|(common)(ly)?( used)?) hashtag/) &&
      !answer.match(/\d/)
      most_popular_hashtag
    elsif
      (answer.match(/most ((popular)|(liked)) tweet$/) ||
      answer.match(/tweet.*most.*like.{1,2}$/)) &&
      !answer.match(/\d/)
      most_popular_tweet

    ### RELATIONS ##

    elsif
      answer.match(/all (of )?(.+)'s tweets/) ||
      answer.match(/all tweets (.*)((from)|(by)) (.*)/)
      input =
      answer.match(/all (of )?(.+)'s tweets/) ||
      answer.match(/all tweets (.*)((from)|(by)) (.*)/)
      all_user_tweets(input)
    elsif answer.match(/all (of )?(.+)'s hashtags/) || answer.match(/all hashtags .*by (.*)/)
      input = answer.match(/all (of )?(.+)'s hashtags/) || answer.match(/all hashtags .*by (.*)/)
      all_user_hashtags(input)
    elsif
      answer.match(/(A|a)ll.*tweets.*#(.*)/) ||
      answer.match(/((tweeting)|(saying)).*#(.*)/)
      input =
      answer.match(/(A|a)ll.*tweets.*#(.*)/) ||
      answer.match(/((tweeting)|(saying)).*#(.*)/)
      all_hashtag_tweets(input)
    elsif
      answer.match(/(A|a)ll.*((users)|(people)|(accounts)).*((hashtag )|(#))(.*)/) || # Show me all the people tweeting about #<hashtag>
      answer.match(/(E|e)veryone.*((about )|(#))(.*)/) # Show me everyone who is tweeting about #<hashtag>
      input =
      answer.match(/(A|a)ll.*((users)|(people)|(accounts)).*((hashtag )|(#))(.*)/) ||
      answer.match(/(E|e)veryone.*((about )|(#))(.*)/)
      all_hashtag_users(input)
    elsif
      answer.match(/((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)'s (?:(?:top)|(?:most popular)|(?:most liked)) tweets/) ||
      answer.match(/(?:(?:top)|(?:most popular)|(?:most liked)) tweets (?:(?:by)|(?:from)) (.*)/)
      input =
      answer.match(/((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)'s (?:(?:top)|(?:most popular)|(?:most liked)) tweets/) ||
      answer.match(/(?:(?:top)|(?:most popular)|(?:most liked)) tweets (?:(?:by)|(?:from)) (.*)/)
      user_top_tweets(input)
    elsif
      ((answer.match(/((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)'s most common(?:ly used)? hashtags/) || # What are <name>'s most commonly used hashtags?
      answer.match(/hashtags does((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)(?:(?:tweet)|(?:use)).*most?/)) || # What hashtags does <name> use the most?
      answer.match(/hashtags.*most.*(?:(?:tweet)|(?:use)).*by((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)\?/)) || # What are the hashtags most commonly tweeted by <name>?
      answer.match(/hashtags.*(?:(?:tweet)|(?:use)).*most.*by ((?:(?:[A-Z])|(?:@)).+(?:(?:\s\w+))?)\?/) # What hashtags are used most by <name>
      input =
      ((answer.match(/((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)'s most common(?:ly used)? hashtags/) ||
      answer.match(/hashtags does((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)(?:(?:tweet)|(?:use)).*most?/)) ||
      answer.match(/hashtags.*most.*(?:(?:tweet)|(?:use)).*by((?:(?:\s[A-Z])|(?:@)).+(?:(?:\s.+))?)\?/)) ||
      answer.match(/hashtags.*(?:(?:tweet)|(?:use)).*most.*by ((?:(?:[A-Z])|(?:@)).+(?:(?:\s\w+))?)\?/)
      user_top_hashtags(input)
    elsif
      answer.match(/most (?:(?:liked)|(?:popular)) tweets.*((?:(?:#)|(?:[A-Z])).+)/)
      input = answer.match(/most (?:(?:liked)|(?:popular)) tweets.*((?:(?:#)|(?:[A-Z])).+)/)
      hashtag_top_tweets(input)
    elsif
      answer.match(/Which.*about ((?:(?:#)|(?:[A-Z]))\w+)\s.*most/)
      input = answer.match(/Which.*about ((?:(?:#)|(?:[A-Z]))\w+)\s.*most/)
      hashtag_top_users(input)

    ### SENTIMENT ###

    elsif
      answer.match(/friend(s)? table/) ||
      answer.match(/table.*friend(s)?/)
      friends_table
    elsif
      answer.match(/hashtag(s)? table/) ||
      answer.match(/table.*hashtag(s)?/)
      hashtags_table
    elsif
      answer.match(/most positive ((person)|(friend))/) ||
      answer.match(/((person)|(friend)).*most positive/)
      most_positive_friend
    elsif
      answer.match(/most negative ((person)|(friend))/) ||
      answer.match(/((person)|(friend)).*most negative/)
      most_negative_friend
    elsif
      answer.match(/most positive tweet/) ||
      answer.match(/tweet is( the)?most positive/)
      most_positive_tweet
    elsif
      answer.match(/most negative tweet/) ||
      answer.match(/tweet is( the)? most negative/)
      most_negative_tweet|| answer.match(/((person)|(friend)).*most negative/)
    elsif
      answer.match(/most positive hashtag/) ||
      answer.match(/hashtag is( the)? most positive/)
      most_positive_hashtag
    elsif
      answer.match(/most negative hashtag/) ||
      answer.match(/hashtag is( the)? most negative/)
      most_negative_hashtag
    elsif
      answer.match(/average(\s)?(friend)? sentiment( of my friends)?/)
      average_friend_sentiment

    ### TOP 10s ###

    elsif
      answer.match(/top 10(\s)?(most )?((popular)|(followed))? ((friends)|(people))/)
      top_ten_most_popular_friends
    elsif
      answer.match(/top 10(\s)?(most )?((popular)|(liked))? tweets/)
      top_ten_most_popular_tweets
    elsif
      answer.match(/top 10(\s)?(most )?((popular)|(common)(ly)?( used)?)? hashtag(s)?/)
      top_ten_most_popular_hashtags

    ### ALL INFO ###

    elsif
      answer.match(/((all users)|(everyone)).*database/)
      all_user_info
    elsif
      answer.match(/((all)|(every)) (the )?hashtag(s)?/)
      all_hashtag_info

    ### EASTER EGGS ###

    elsif
      answer.match(/((joke)|(funny))/)
      random_joke
    elsif
      answer.match(/((cat)|(kitty)|(meow))/)
      random_cat_fact
    else
      err
    end
  end
end

def help
  puts "\nHere's a list of available commands:\n\n"
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
  puts "  - all users in the database".cyan
  puts "  - all hashtags\n".cyan
end

def err
  puts "\nInvalid input. Please try again.\n\n"
end

def goodbye
  puts "\nGoodbye!\n\n"
end
