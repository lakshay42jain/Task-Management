require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require 'bcrypt'

class User
  attr_accessor :name, :email, :password_hash, :type, :connect

  def initialize(name:, email:, password:, type:)
    self.name = name
    self.email = email
    self.password_hash = BCrypt::Password.create(password)
    self.type = type
    self.connect = DatabaseConnection.connection
  end

  def save 
    begin
      connect.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4)", [name, email, password_hash, type])
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

  def self.find_user(email)
    connect = DatabaseConnection.connection
    res = connect.exec_params("SELECT * FROM users WHERE email=$1", [email])
    return User.new(
      name: res[0]['name'],
      email: res[0]['email'],
      password: res[0]['password'],
      type: res[0]['type']
    )
  end
end
