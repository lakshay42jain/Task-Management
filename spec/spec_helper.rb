require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
end

require 'rspec'
require 'pg'
require 'bcrypt'
require 'dotenv'
require_relative '../models/task.rb'
require_relative '../models/user.rb'
require_relative '../services/database_connection.rb'
require_relative '../services/login_service.rb'
require_relative '../services/sign_up_service.rb'
require_relative '../services/task_manager.rb'
require_relative '../table_setup.rb'

Dotenv.load('.env.test')

RSpec.configure do |config|
  config.before(:suite) do
    connection = DatabaseConnection.connection
    table_setup = TableSetup.new(connection)
    table_setup.setup_database
  end
end
