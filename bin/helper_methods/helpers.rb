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
  user = input.captures[-1].strip
  user.start_with?("@") ? User.find_by(twitter_handle: user.split("")[1..-1].join("")) : User.find_by(name: user)
end

def find_hashtag(input)
  hashtag = input.captures[-1].strip
  hashtag.start_with?("#") ? Hashtag.find_by(title: hashtag.split("")[1..-1].join("")) : Hashtag.find_by(title: hashtag)
end

def format_tweet(user, tweet)
  puts "\n#{user.name}" + " @#{user.twitter_handle}".yellow
  puts "#{tweet.date_posted.strftime("%A, %b %d %Y")} #{tweet.date_posted.strftime("%I:%M")}"
  puts "\n#{tweet.content}\n"
  print "\u{2764} #{tweet.likes}"
  print "   "
  puts "\u{27F2} #{tweet.retweets}"
  puts "\n*----------------------------------------------*\n\n"
  sleep(0.5)
end
