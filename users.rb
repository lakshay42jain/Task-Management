require './TableSetup.rb'

class Users
  attr_accessor :name, :email, :password, :type

  def initialize(args = {})
    self.name = args[:name]
    self.email = args[:email]
    self.password = args[:password]
    self.type = args[:type]
  end

  def save 
    begin
      DB_CONNECTION.connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4)",[name, email, password, type])
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
