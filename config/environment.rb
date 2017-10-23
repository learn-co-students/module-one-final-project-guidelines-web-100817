require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'

require_relative './twitter_client_config.rb'
client = Twitter::REST::Client.new(config)