### BASICS ###
def number_of_friends
  puts "\nYou're following #{User.first.following.to_s.light_green} people, and #{(User.all.count - 1).to_s.light_green} of them are currently in the database.\n\n"
end

def number_of_tweets
  puts "\nThere are currently #{(Tweet.all.count - User.first.tweets.count).to_s.light_green} tweets from your friends in the database, and #{(User.first.tweets.count).to_s.light_green} from you.\n\n"
end

def number_of_hashtags
  print "\nThe tweets in the database contain #{(Hashtag.all.count).to_s.light_green} individual hashtags, used a total of #{(TweetHashtag.all.count).to_s.light_green} times. "
  taste_the_rainbow("#octothorpe")
  puts "\n\n"
end

def get_details_for_user(input)
  user = find_user(input)
  if user
    format_details(user)
  else
    puts "\nHmm... I couldn't seem to find who you were looking for.\n\n"
  end
end
