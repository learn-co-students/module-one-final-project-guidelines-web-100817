require 'bundler/setup'
Bundler.require

require 'active_record'
require 'rake'
require 'yaml/store'
require 'ostruct'
require 'date'
require 'require_all'
require 'rspotify'

DBNAME = "spotify"

require_all "app"

Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "../lib/support", "*.rb")].each {|f| require f}

# DBRegistry[ENV["ACTIVE_RECORD_ENV"]].connect!
# DB = ActiveRecord::Base.connection
ActiveRecord::Base.establish_connection(adapter:"sqlite3",database: "db/spotify-development.db")

# if ENV["ACTIVE_RECORD_ENV"] == "test"
#   ActiveRecord::Migration.verbose = false
# end
