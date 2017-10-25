### RELATIONS ###
def all_user_tweets
  user = find_user($input)
  puts "\nHere are all the tweets from #{user.name}:\n\n"
  user.tweets.each do |tweet|
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}"
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def all_user_hashtags
  user = find_user($input)
  puts "\nHere are all the hashtags used by #{user.name}:\n\n"
  user.hashtags.each do |hashtag|
    puts "\##{hashtag.title}"
  end
end

def all_hashtag_users
  hashtag = find_hashtag($input)
  puts "\nHere are all the people who have tweeted about \##{hashtag.title}:\n\n"
  hashtag.users.each do |user|
    puts user.name
  end
end

def all_hashtag_tweets
  hashtag = find_hashtag($input)
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
  user = find_user($input)
  puts "\nHere are the top 5 tweets from #{user.name}:\n\n"
  user.tweets.order("tweets.likes DESC").limit(5).each do |tweet|
    puts "#{tweet.content}"
    print "\u{2764}: #{tweet.likes}"
    puts "\u{27F2}: #{tweet.retweets}"
    puts "*----------------------*"
  end
end

def user_top_hashtags
  user = find_user($input)
  puts "\nHere are hashtags most commonly used by #{user.name}:\n\n"
  Hashtag.joins(:tweets).where("tweets.user_id = ?", user.id).group("hashtags.title").order("count(hashtags.title) DESC").each do |hashtag|
    puts "\##{hashtag.title}: #{Hashtag.joins(:tweets).where("hashtags.id = #{hashtag.id}").count}"
  end
  puts ""
end

def hashtag_top_tweets
  hashtag = find_hashtag($input)
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
  hashtag = find_hashtag($input)
  User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = 335").group("users.id").order("count(users.id) DESC").each do |user|
    puts "\##{user.name}: #{User.joins(tweets: [:tweet_hashtags]).where("tweet_hashtags.hashtag_id = #{hashtag.id}").count}"
  end
  puts ""
end
