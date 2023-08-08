require 'rspec'
require 'pg'
require 'bcrypt'
require 'dotenv'
require 'simplecov'
Dotenv.load('.env.test')

SimpleCov.start

RSpec.configure do |config|
  config.before(:suite) do
    connection = DatabaseConnection.connection
    table_setup = TableSetup.new(connection)
    table_setup.setup_database
  end
end
