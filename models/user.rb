require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require 'bcrypt'

class User
  attr_accessor :name, :email, :password, :type, :connect, :id

  def self.connection
    @@connection ||= DatabaseConnection.connection 
  end

  private def connection
    @connection ||= User.connection
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
      if id.nil?
        result = connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1, $2, $3, $4) RETURNING *", [name, email, BCrypt::Password.create(password), type])
        if result.ntuples.nonzero?
          self.id = result[0]['id']
          puts "User Created Successfully" 
        end
        self
      end
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    end
  end

  def admin?
    type == 'admin'
  end

  def self.find_by_email(email)
    result = connection.exec_params("SELECT * FROM users WHERE email=$1", [email])
    if result.ntuples.nonzero?
      result = result[0].transform_keys(&:to_sym)
      User.new(
        id: result[:id].to_i,
        name: result[:name],
        email: result[:email],
        password: result[:password],
        type: result[:type]
      )
    else
      puts "Email Does Not exist !!"
    end
  end
end
