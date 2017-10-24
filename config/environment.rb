require 'bundler'
Bundler.require

require 'rake'
require 'active_record'
require 'yaml/store'
require 'ostruct'
# require 'date'
#
Dir[File.join(File.dirname(__FILE__), "../app/models", "*.rb")].each {|f| require f}
# Dir[File.join(File.dirname(__FILE__), "../lib", "*.rb")].each {|f| require f}

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
require_all 'lib'
