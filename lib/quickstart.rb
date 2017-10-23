# [START language_quickstart]
# Imports the Google Cloud client library
require "google/cloud/language"

# Your Google Cloud Platform project ID
project_id = "mod1-final-project"

# Instantiates a client
language = Google::Cloud::Language.new project: project_id

# The text to analyze
text     = "You suck!"
document = language.document text

# Detects the sentiment of the text
sentiment = document.sentiment

puts "Text: #{text}"
puts "Score: #{sentiment.score}, #{sentiment.magnitude}"
# [END language_quickstart]
