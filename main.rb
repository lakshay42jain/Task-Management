require './table_setup.rb'
require_relative 'services/database_connection.rb'
require_relative 'models/user.rb'
require_relative 'models/task.rb'
require 'date'
require 'bcrypt'
require_relative './application.rb'

connection = DatabaseConnection.connection
table_setup = TableSetup.new(connection)
table_setup.setup_database
Application.boot
