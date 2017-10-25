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
