require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "WrFiASTYdEk5Y0VSFQZ211MdR"
  config.consumer_secret     = "9U3ZhwflnRCEmgmIs5GU3nCXtJ9czK9RsgaGAxv45qZcAV1JoO"
  config.access_token        = "3429855759-cEUza6Zagn5PMsL1YxH3bMmnziupVq9i2XEk15w"
  config.access_token_secret = "BJHoQUEj9LGMIlK28Q5Bt8p7k1M9ltU7WkB1C8KM5DALY"
end