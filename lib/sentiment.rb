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

  def self.get_avg_for_user(user)
    total = user.tweets.inject(0) do |memo, tweet|
      memo += tweet.sentiment_score
    end
    (total / user.tweets.length).round(2).to_f
  end

end
