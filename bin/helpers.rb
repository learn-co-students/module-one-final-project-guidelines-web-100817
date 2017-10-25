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