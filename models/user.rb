require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require 'bcrypt'

class User
  attr_accessor :name, :email, :password, :type, :connect, :id
  @@connection = nil 

  def self.connection
    @@connection ||= DatabaseConnection.connection 
  end

  def initialize(name:, email:, password:, type:, id: nil)
    self.id = id
    self.name = name
    self.email = email
    self.password = password
    self.type = type
  end

  def save 
    begin
      user = User.find_by_email(email)
      if user.nil?
        User.connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4)", [name, email, BCrypt::Password.create(password), type])
        puts "User Created Successfully"
      else
        puts "email id already exist"
      end
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    end
  end

  def self.find_by_email(email)
    result = User.connection.exec_params("SELECT * FROM users WHERE email=$1", [email])
    if result.ntuples >= 1
      User.new(
        id: result[0]['id'].to_i,
        name: result[0]['name'],
        email: result[0]['email'],
        password: result[0]['password'],
        type: result[0]['type']
      )
    else
      nil
    end
  end
end
