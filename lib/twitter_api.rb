class TwitterApi

  attr_accessor :client

  def initialize
    keys = YAML.load_file('config/application.yml')
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = keys['consumer_key']
      config.consumer_secret     = keys['consumer_secret']
      config.access_token        = keys['access_token']
      config.access_token_secret = keys['access_token_secret']
    end
  end

  def most_recent_friend
    client.friends.first
  end
  
end