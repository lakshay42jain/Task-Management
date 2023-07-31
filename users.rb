require './database_setup.rb'

class User
  attr_accessor :name,:email,:password,:user_type

  def initialize(name,email,password,user_type)
    self.name=name
    self.email=email
    self.password=password
    self.user_type=user_type
  end


  def save 
    connection=PG.connect(dbname: 'postgres',user: 'lakshayjain' , host: 'localhost')
    connection.exec_params("INSERT INTO users (name,email,password,user_type) VALUES($1 , $2, $3, $4)",[self.name,self.email,self.password,self.user_type])
  end
end
