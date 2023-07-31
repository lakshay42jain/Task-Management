require './database_setup.rb'

class User
  attr_accessor :name, :email, :password, :type

  def initialize(name, email, password, type)
    self.name = name
    self.email = email
    self.password = password
    self.type = type
  end

  def save 
    db = DatabaseSetup.new
    db.connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1 , $2, $3, $4)",[name, email, password, type])
  end
end
