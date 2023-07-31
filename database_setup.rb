require 'pg'


class DatabaseSetup
  attr_accessor :connection

  def initialize
    self.connection=PG.connect(dbname: 'postgres' , user: 'lakshayjain' , host: 'localhost')
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
            name VARCHAR(20),
            email VARCHAR(50),
            password VARCHAR(20),
            type admin_enum
          );
  
          CREATE TYPE status_enum AS ENUM (
            'pending',
            'due',
            'in_progress',
            'under_review',
            'closed'
        );
  
          CREATE TABLE IF NOT EXISTS tasks(
            id INTEGER,
            assignee_user_id INTEGER REFERENCES users(id),
            description TEXT,
            due_date DATE,
            priority INTEGER,
            creator_id INTEGER REFERENCES users(id), 
            status status_enum
          );
        SQL
      )
      puts "Database Connection Established users and tasks table created successfully" 
      
      rescue PG::Error => e 
        puts e 
  
      else
        "Created Successfully"
  
      ensure
        "______________________"
  
      end
  
  end
  

end


