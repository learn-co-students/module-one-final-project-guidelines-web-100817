require "google/cloud/language"
# puts "Text: #{text}"
# puts "Score: #{sentiment.score}, #{sentiment.magnitude}"

class Sentiment
  def self.get_sentiment_score(tweet)
    # Your Google Cloud Platform project ID
    project_id = "mod1-final-project"
    # Instantiates a client
    language = Google::Cloud::Language.new project: project_id
    document = language.document(tweet.content)
    score = document.sentiment.score
    tweet.sentiment_score = score
    tweet.save
  end

  def self.get_avg_sentiment
    total = Tweet.all.inject(0) do |memo, tweet|
      memo += tweet.sentiment_score
    end
    (total / user.tweets.length).round(2).to_f
  end

  def self.get_avg_for_user(user)
    total = user.tweets.inject(0) do |memo, tweet|
      memo += tweet.sentiment_score
    end
    (total / user.tweets.length).round(2).to_f
  end

  def self.populate_sentiment_scores
    Tweet.all.each do |tweet|
      Sentiment.get_sentiment_score(tweet)
    end
  end

  def self.user_sentiment_hash
    User.all.inject({}) do |memo, user|
      memo[user.name] = self.get_avg_for_user(user)
      memo
    end
  end

  def self.most_positive_friend
    self.user_sentiment_hash.find {|name, score| score == self.user_sentiment_hash.values.max}[0]
  end

  def self.most_negative_friend
    self.user_sentiment_hash.find {|name, score| score == self.user_sentiment_hash.values.min}[0]
  end

  def self.most_positive_tweet
    tweet = Tweet.order("sentiment_score DESC").first
    user = User.find(tweet.user_id)
    "#{user.name} said: #{tweet.content}"
  end

  def self.most_negative_tweet
    tweet = Tweet.order("sentiment_score ASC").first
    user = User.find(tweet.user_id)
    "#{user.name} said: #{tweet.content}"
  end

  def self.get_sentiment_array
    self.user_sentiment_hash.to_a.sort_by {|x| x[1]}
  end

  def self.sentiment_table
    rows = self.get_sentiment_array
    rows.each do |row_array|
      row_array << self.make_slider(row_array)
    end
    table = Terminal::Table.new(:headings => ["Name", "Score", "Scale"], :rows => rows)
    puts table
  end

  def self.make_slider(row_array)
    "Negative ----------|---------- Positive"
    str = "Negative "
    if row_array[1] > 0
      str += "-" * 10
      str += "|"
      stars = (row_array[1] * 10 ).round
      str += "*" * stars
      str += "-" * (10 - stars)
      str += " Positive"
    else
      stars = (-row_array[1] * 10).round
      str += "-" * (10 - stars)
      str += "*" * stars
      str += "|---------- Positive"
    end
    str
  end

end
