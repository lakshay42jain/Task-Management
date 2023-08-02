require 'pg'

class DatabaseConnection
  @@connection = nil 

  def self.connection 
    if @@connection.nil?
      begin
        @@connection = PG.connect(
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
    @@connection
  end
end
