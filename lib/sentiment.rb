require "google/cloud/language"

class Sentiment
  def self.get_sentiment_score(tweet)
    # Your Google Cloud Platform project ID
    project_id = ""
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
    (total / Tweet.all.length).round(2).to_f
  end

  def self.get_avg_for_user(user)
    total = user.tweets.inject(0) do |memo, tweet|
      memo += tweet.sentiment_score
    end
    (total / user.tweets.length).round(2).to_f
  end

  def self.populate_sentiment_scores(progress)
    Tweet.all.each do |tweet|
      Sentiment.get_sentiment_score(tweet)
      progress.increment
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
    [user, tweet]
  end

  def self.most_negative_tweet
    tweet = Tweet.order("sentiment_score ASC").first
    user = User.find(tweet.user_id)
    [user, tweet]
  end

  def self.get_array(hash)
    hash.to_a.sort_by {|x| x[1]}
  end

  def self.avg_hashtag_sentiment(hashtag)
    total = hashtag.tweets.inject(0) {|memo, tweet| memo += tweet.sentiment_score}
    (total / hashtag.tweets.length).round(2).to_f
  end

  def self.avg_hashtag_hash
    Hashtag.all.inject({}) do |memo, hashtag|
      memo[hashtag.title] = self.avg_hashtag_sentiment(hashtag)
      memo
    end
  end


  ###MAKE TABLES
  def self.table(hash)
    rows = self.get_array(hash)
    rows.each do |row_array|
      row_array << self.make_slider(row_array)
    end
    table = Terminal::Table.new(:headings => ["Name".yellow, "Score".yellow, "Scale".yellow], :rows => rows)
    puts table
  end

  def self.make_slider(row_array)
    str = "Negative ".red
    if row_array[1] > 0
      str += "-" * 10
      str += "|"
      stars = (row_array[1] * 10 ).round
      str += ("*" * stars).colorize(:green)
      str += "-" * (10 - stars)
      str += " Positive".green
    else
      stars = (-row_array[1] * 10).round
      str += "-" * (10 - stars)
      str += ("*" * stars).colorize(:red)
      str += "|---------- #{"Positive".green}"
    end
    str
  end

end
