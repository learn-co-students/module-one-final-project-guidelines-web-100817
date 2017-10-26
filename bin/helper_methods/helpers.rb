### HELPERS ###
def taste_the_rainbow(string)
  colors = [:light_magenta, :light_red, :light_yellow, :light_green, :light_cyan, :light_blue]
  color_index = 0
  string.split("").each.with_index do |letter, index|
    if index != string.length - 1
      print letter.colorize(colors[color_index])
      color_index < 5 ? color_index += 1 : color_index = 0
    else
      print letter.colorize(colors[color_index])
    end
  end
end

def number_readability(number)
  number.to_s.reverse.scan(/.{1,3}/).join(",").reverse
end

def find_user(input)
  user = input.captures[-1].strip
  if user
    user.start_with?("@") ? User.find_by(twitter_handle: user.split("")[1..-1].join("")) : User.find_by(name: user)
  else
    puts "\nHmm... I couldn't seem to find who you were looking for.\n\n"
  end
end

def find_hashtag(input)
  hashtag = input.captures[-1].strip
  if hashtag
    hashtag.start_with?("#") ? Hashtag.find_by(title: hashtag.split("")[1..-1].join("")) : Hashtag.find_by(title: hashtag)
  else
    puts "\nHmm... I couldn't seem to find what you were looking for.\n\n"
  end
end

def format_tweet(user, tweet)
  puts "\n#{user.name}" + " @#{user.twitter_handle}".yellow
  puts "#{tweet.date_posted.strftime("%A, %b %d %Y")} #{tweet.date_posted.strftime("%I:%M %p")}"
  puts "\n#{tweet.content}\n"
  print "#{"\u{2764}".light_red} #{number_readability(tweet.likes)}"
  print "   "
  puts "#{"\u{27F2}".light_green} #{number_readability(tweet.retweets)}"
  puts "\n*----------------------------------------------*\n\n"
  sleep(0.5)
end

def format_details(user)
  puts "\nHere's everything there is to know about you:"
  puts "\n#{"name:".cyan} #{user.name}"
  puts "#{"username:".cyan} @#{user.twitter_handle}"
  puts "#{"description:".cyan} #{user.description}"
  puts "#{"location:".cyan} #{user.location}"
  puts "#{"# of tweets:".cyan} #{number_readability(user.tweet_count)}"
  puts "#{"# following:".cyan} #{number_readability(user.following)}"
  puts "#{"# of followers:".cyan} #{number_readability(user.followers)}\n\n"
  print "Would you like to view your profile in the browser? "
  answer = gets.chomp
  if answer.match(/(?:[Yy]$)|(?:[Yy]es)|(?:[Ss]ure)/)
    twitter_url = "https://twitter.com/#{user.twitter_handle}"
    `open #{twitter_url}`
    print "\nThere you go. "
  else
    print "Suit yourself. "
  end
end
