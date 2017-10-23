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
    tweet.sentiment_score = score.round(2).to_f
    tweet.save
  end

end
