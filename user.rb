require './table_setup.rb'
require './database_connection.rb'

class User
  attr_accessor :name, :email, :password, :type

  def initialize(name: nil, email: nil, password: nil, type: 'user')
    self.name = name
    self.email = email
    self.password = password
    self.type = type
  end

  def save 
    begin
      connection = DatabaseConnection.connection
      connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4)",[name, email, password, type])
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
