require 'pg'

class DatabaseConnection
  attr_accessor :connection

  def initialize
    begin
      self.connection = PG.connect(
        dbname: 'postgres',
        user: ENV['DATABASE_USER'],
        host: ENV['DATABASE_HOST']
      )
    rescue PG::ConnectionBad => e
      puts "Bad Connection"  
      puts e.message
      exit
    else
      puts "Connection Initialized Successfully"
    end
  end
end
