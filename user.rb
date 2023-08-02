require './table_setup.rb'
require './database_connection.rb'
require 'bcrypt'

class User
  attr_accessor :name, :email, :password_hash, :type

  def initialize(name:, email:, password:, type:)
    self.name = name
    self.email = email
    self.password_hash = BCrypt::Password.create(password)
    self.type = type
  end

  def save 
    begin
      connection = DatabaseConnection.connection
      connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4)", [name, email, password_hash, type])
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    else
      puts "User Created Successfully"
    end
  end
end