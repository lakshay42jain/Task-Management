require 'pg'

class DatabaseConnection
  @@connection = nil 
  def self.connection 
    if @@connection.nil?
      begin
        @@connection ||= PG.connect(
          dbname: ENV['DATABASE_NAME'],
          user: ENV['DATABASE_USER'],
          host: ENV['DATABASE_HOST'],
          port: ENV['DATABASE_PORT']
        )  
      rescue PG::ConnectionBad => e
        initial_connection = PG.connect(
          dbname: 'postgres',
          user: ENV['DATABASE_USER'],
          host: ENV['DATABASE_HOST'],
          port: ENV['DATABASE_PORT']
        )
        initial_connection.exec("CREATE DATABASE #{ENV['DATABASE_NAME']}")
        initial_connection.close  
        puts "Database Successfully Created"  
      end
    end
    @@connection
  end

  def self.clear_tables
    @@connection.exec("DELETE FROM tasks;")
    @@connection.exec("DELETE FROM users;")
  end
end
