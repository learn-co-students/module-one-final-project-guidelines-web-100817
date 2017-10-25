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

def get_details_for_user(input)
  user = find_user(input)
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
