require './database_setup.rb'

class User
  attr_accessor :name, :email, :password, :user_type

  def initialize(name, email, password, type)
    self.name=name
    self.email=email
    self.password=password
    self.type=user_type
  end

  db=DatabaseSetup.new
  def save 
    db.connection.exec_params("INSERT INTO users (name, email, password, type) VALUES($1 , $2, $3, $4)",[name, email, password, type])
  end
end
