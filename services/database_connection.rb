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
        puts
      rescue PG::ConnectionBad => e
        puts "Bad Connection"  
        puts e.message
        exit
      end
    end
    @@connection
  end
end
