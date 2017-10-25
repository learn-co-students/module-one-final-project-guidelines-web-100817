### BASICS ###
def number_of_friends
  puts "\nYou have #{(User.all.count - 1).to_s.light_green} friends. Not so bad. Could be better. You should get out more.\n\n"
end

def number_of_tweets
  puts "\nYour friends have tweeted #{(Tweet.all.count - User.first.tweets.count).to_s.light_green} times, and you have tweeted #{(User.first.tweets.count).to_s.light_green} times. Like... whoa.\n\n"
end

def number_of_hashtags
  print "\nYou and your friends have used #{(Hashtag.all.count).to_s.light_green} hashtags a total of #{(TweetHashtag.all.count).to_s.light_green} times. "
  taste_the_rainbow("#octothorpe")
  puts ""
end

def get_details_for_user(input)
  user = find_user(input)
  if user
    puts "\nHere's everything there is to know about #{user.name.light_green}:"
    puts "\n#{"name:".cyan} #{user.name}"
    puts "#{"username:".cyan} @#{user.twitter_handle}"
    puts "#{"location:".cyan} #{user.location}"
    puts "#{"# following:".cyan} #{number_readability(user.following)}"
    puts "#{"# of followers:".cyan} #{number_readability(user.followers)}\n\n"
  else
    puts "\nHmm... I couldn't seem to find who you were looking for.\n"
  end
end
