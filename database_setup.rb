require 'pg'

class DatabaseSetup
  attr_accessor :connection

  def initialize
    begin
      self.connection = PG.connect(
        dbname: 'postgres',
        user: ENV['DATABASE_USER'],
        host: ENV['DATABASE_HOST'])
    rescue PG::ConnectionBad => e
      puts "Bad Connection"  
      puts e.message
    else
      puts "Connection Initialized Succesfully"
    end
  end
  
  def setup_database
    begin
      connection.exec(
        <<~SQL
          CREATE TYPE admin_enum AS ENUM(
            'admin',
            'user'
          );
          CREATE TABLE IF NOT EXISTS users(
            id SERIAL PRIMARY KEY,
            name VARCHAR(20) NOT NULL,
            email VARCHAR(50) UNIQUE NOT NULL,
            password VARCHAR(20) NOT NULL,
            type admin_enum NOT NULL
          );
          CREATE TYPE status_enum AS ENUM (
            'pending',
            'due',
            'in_progress',
            'under_review',
            'closed'
          );
          CREATE TABLE IF NOT EXISTS tasks(
            id INTEGER NOT NULL,
            assignee_user_id INTEGER REFERENCES users(id) NOT NULL,
            description TEXT NOT NULL,
            due_date DATE NOT NULL,
            priority INTEGER NOT NULL,
            creator_id INTEGER REFERENCES users(id) NOT NULL, 
            status status_enum NOT NULL
          );
        SQL
      )
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message
    else
      puts "Database Connection Established (users and tasks table created successfully)" 
    end
  end
end
