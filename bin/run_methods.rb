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

### BASICS ###
def number_of_friends
  puts "\nYou have #{User.all.count - 1} friends. Not so bad. Could be better. You should get out more.\n\n"
end

def number_of_tweets
  puts "\nYour friends have tweeted #{Tweet.all.count} times. Like... whoa.\n\n"
end

def number_of_hashtags
  print "\nYour friends have used #{Hashtag.all.count} hashtags a total of #{TweetHashtag.all.count} times. "
  taste_the_rainbow("#octothorpe")
  puts ""
end

def get_details_for_user
  user = find_user
  if user
    puts "Here's everything we know about #{user.name}:"
    puts "\nname: #{user.name}"
    puts "username: #{user.twitter_handle}"
    puts "location: #{user.location}"
    puts "# following: #{number_readability(user.following)}"
    puts "# of followers: #{number_readability(user.followers)}"
  else
    puts "Hmm... I couldn't seem to find who you were looking for."
  end
end

### ABOUT ME ###
def my_sentiment
  sentiment = Sentiment.get_avg_for_user(User.first)
  puts "\nYour sentiment score is currently: #{sentiment}"
  if sentiment < -0.5
    sentiment = "dreadful"
  elsif sentiment < 0
    sentiment = "downer"
  elsif sentiment < 0.5
    sentiment = "slightly happy"
  else
    sentiment = "beaming"
  end
  puts "That means that you've probably been #{sentiment} lately."
end

def my_most_popular_tweet
  user = User.first
  tweet = user.tweets.order("likes DESC").first
  puts "\nWow, a lot of people like this tweet! #{number_readability(tweet.likes)} people, to be exact."
  format_tweet(user, tweet)
end

def my_most_positive_tweet
  tweet = User.first.tweets.order("sentiment_score DESC").first
  puts "\nDid you meet a tiny duck in boots just before you tweeted this?"
  format_tweet(User.first, tweet)
end

def my_most_negative_tweet
  tweet = User.first.tweets.order("sentiment_score ASC").first
  puts "\nGeez, you didn't have to kick over my half-full glass."
  format_tweet(User.first, tweet)
end

def my_average_tweeting_time
  user = User.first
  time1 = user.tweets.last.date_posted
  time2 = user.tweets.first.date_posted
  avg = (((time2 - time1) / 1.hour).round) / user.tweets.length
  if avg < 10
    puts "\nWow, looks you only wait an average of #{avg} hours between tweets. Needy much?"
  elsif avg < 24
    puts "\nYou tweet, on average, once every #{avg} hours."
  else
    puts "\nYou only tweet once every #{avg} hours. You should probably tweet more if you want people to care."
  end
end

### POPULARITY ###
def most_popular_friend
  most_popular_friend = User.order("followers DESC").first
  puts "\nThe most popular person you follow is #{most_popular_friend.name}."
  print "They have "
  print "#{number_readability(most_popular_friend.followers)} ".light_red
  puts "followers. Wowza!\n\n"
end

def most_popular_tweet
  most_popular_tweet = Tweet.order("likes DESC").first
  puts "\nThe most popular tweet made by the people you follow was this one by #{most_popular_tweet.user.name}:"
  puts "#{most_popular_tweet.content}".yellow
  puts "It has #{number_readability(most_popular_tweet.likes).light_red} likes and #{number_readability(most_popular_tweet.retweets).light_red} retweets. Good stuff.\n\n"
end

def most_popular_hashtag
  most_popular_hashtag = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").first
  tweeters = {}
  most_popular_hashtag.users.each {|tweeter| tweeters[tweeter.name] ? tweeters[tweeter.name] += 1 : tweeters[tweeter.name] = 1}
  puts "\nThe most popular hashtag among your friends is \##{most_popular_hashtag.title}"
  puts "It has been tweeted about #{most_popular_hashtag.tweets.count} times."
  puts "The person who has tweeted it most is #{tweeters.key(tweeters.values.max)}. They have tweeted it #{tweeters.values.max} times.\n\n"
end

### RELATIONS ###
def all_user_tweets
  user = find_user
  puts "\nHere are all the tweets from #{user.name}:\n\n"
  user.tweets.each do |tweet|
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}   "
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def all_user_hashtags
  user = find_user
  puts "\nHere are all the hashtags used by #{user.name}:\n\n"
  user.hashtags.each do |hashtag|
    puts "\##{hashtag.title}"
  end
end

def all_hashtag_users
  hashtag = find_hashtag
  puts "\nHere are all the people who have tweeted about \##{hashtag.title}:\n\n"
  hashtag.users.each do |user|
    puts user.name
  end
end

def all_hashtag_tweets
  hashtag = find_hashtag
  puts "\nHere are all the tweets about \##{hashtag.title}:\n\n"
  hashtag.tweets.each do |tweet|
    puts "#{tweet.user.name} tweeted:"
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}"
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def user_top_tweets
  user = find_user
  puts "\nHere are the top 5 tweets from #{user.name}:\n\n"
  user.tweets.order("tweets.likes DESC").limit(5).each do |tweet|
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}"
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def user_top_hashtags
  user = find_user
  puts "\nHere are hashtags most commonly used by #{user.name}:\n\n"
  Hashtag.joins(:tweets).where("tweets.user_id = ?", user.id).group("hashtags.title").order("count(hashtags.title) DESC").each do |hashtag|
    puts "\##{hashtag.title}: #{Hashtag.joins(:tweets).where("hashtags.id = #{hashtag.id}").count}"
  end
  puts ""
end

def hashtag_top_tweets
  hashtag = find_hashtag
  puts "\nHere are the most popular tweets about \##{hashtag.title}:\n\n"
  hashtag.tweets.order("tweets.likes DESC").each do |tweet|
    puts "#{tweet.user.name} tweeted:"
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}"
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def hashtag_top_users
  hashtag = find_hashtag
  User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = 335").group("users.id").order("count(users.id) DESC").each do |user|
    puts "\##{user.name}: #{User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = #{hashtag.id}").count}"
  end
  puts ""
end

### SENTIMENT ###
def friend_table
  puts "\nHere's a table of how positive or negative your friends are:"
  Sentiment.table(Sentiment.user_sentiment_hash)
  puts "\n\n"
end

def hashtag_table
  puts "\nHere's a table of how positive or negative all the hashtags are:"
  Sentiment.table(Sentiment.avg_hashtag_hash)
  puts "\n\n"
end

def most_positive_friend
  puts "\nLooks like #{Sentiment.most_positive_friend} is a real ray of sunshine.\n\n"
end

def most_negative_friend
  puts "\nIs it true that #{Sentiment.most_negative_friend} is always a bummer?\n\n"
end

def most_positive_tweet
  puts "\nDoes this make you happy?"
  puts "#{Sentiment.most_positive_tweet}\n\n"
end

def most_negative_tweet
  puts "\nBack in MY day, we walked uphill everywhere we went."
  puts "#{Sentiment.most_negative_tweet}\n\n"
end

def average_friend_sentiment
  puts "\nThe average mood of the people you follow is:"
  sentiment = Sentiment.get_avg_sentiment
  puts sentiment
  if sentiment < -0.5
    sentiment = "dreadful"
  elsif sentiment < 0
    sentiment = "downer"
  elsif sentiment < 0.5
    sentiment = "slightly happy"
  else
    sentiment = "beaming"
  end
  puts "That means you're surrounded by #{sentiment} people."
end

def most_positive_hashtag
  hash = Sentiment.avg_hashtag_hash
  title = hash.find {|name, score| score == hash.values.max}[0]
  puts "\nIf you want to be cruel, you should tweet with \##{title}.\n\n"
end

def most_negative_hashtag
  hash = Sentiment.avg_hashtag_hash
  title = hash.find {|name, score| score == hash.values.min}[0]
  puts "\nTo wallow in your misery with other likeminded people, use \##{title}.\n\n"
end

### TOP 10 ###
def top_ten_popular_friends
  users = User.order("users.followers DESC").take(10)
  rows = users.inject([]) do |memo, user|
    memo << [user.name, user.twitter_handle, number_readability(user.followers)]
    memo
  end
  table = Terminal::Table.new(:headings => ["Name".yellow, "Twitter Handle".yellow, "Followers".yellow], :rows => rows)
  puts table
end

def top_ten_popular_tweets
  tweets = Tweet.order("likes DESC").take(10)
  puts "\n\n"
  tweets.each do |tweet|
    user = User.find(tweet.user_id)
    format_tweet(user, tweet)
    puts "\n-------------------------------------------------\n\n"
    sleep(0.75)
  end
end

def top_ten_popular_hashtags
  hashtags = Hashtag.joins(:tweet_hashtags).group("tweet_hashtags.hashtag_id").order("COUNT(tweet_hashtags.hashtag_id) DESC").take(10)
  rows = hashtags.inject([]) do |memo, hashtag|
    memo << ["\##{hashtag.title}", hashtag.tweets.count]
  end
  table = Terminal::Table.new(:headings => ["Hashtag".yellow, "\# of Tweets".yellow], :rows => rows)
  puts table
end

### ALL INFO ###
def all_user_info
  rows = User.all.order(:name).inject([]) do |memo, user|
    memo << [user.name, "@#{user.twitter_handle}", user.location, number_readability(user.following), number_readability(user.followers)]
  end
  table = Terminal::Table.new(:headings => ["Name".yellow, "Twitter Handle".yellow, "Location".yellow, "Following".yellow, "Followers".yellow], :rows => rows)
  puts table
end

def all_hashtag_info
  rows = Hashtag.all.order(:title).inject([]) do |memo, hashtag|
    memo << ["\##{hashtag.title}", hashtag.tweets.count]
  end
  table = Terminal::Table.new(:headings => ["Title".yellow, "\# of Tweets"], :rows => rows)
  puts table
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

def find_user
  input = $input.captures[-1]
  input.start_with?("@") ? User.find_by(twitter_handle: input.split("")[1..-1].join("")) : User.find_by(name: input)
end

def find_hashtag
  input = $input.captures[-1]
  input.start_with?("#") ? Hashtag.find_by(title: input.split("")[1..-1].join("")) : Hashtag.find_by(title: input)
end

def format_tweet(user, tweet)
  puts "\n#{user.name}" + " @#{user.twitter_handle}".yellow
  puts "#{tweet.date_posted.strftime("%A, %b %d %Y")} #{tweet.date_posted.strftime("%I:%M")}"
  puts "\n#{tweet.content}\n"
  puts "#{tweet.likes} \u{2764}\n\n"
end
