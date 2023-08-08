require 'rspec'
require 'pg'
require 'bcrypt'
require 'dotenv/load'
require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseConnection.connection
  end
end
