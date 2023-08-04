require 'pg'
require_relative 'services/database_connection.rb'

class TableSetup
  attr_accessor :connection

  def initialize(connection)
    self.connection=connection
  end

  def setup_database
    create_enum_table 
    create_users_table
    create_tasks_table
  end

  def create_enum_table
    begin
      self.connection.exec(
        <<~SQL
          CREATE TYPE admin_enum AS ENUM(
            'admin',
            'user'
          );
          CREATE TYPE status_enum AS ENUM(
            'pending',
            'due',
            'in_progress',
            'under_review',
            'closed'
          );
        SQL
      )
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query for enums.'
      puts e.message
    else
      puts "Enum Types Created Successfully"  
    end
  end
    
  def create_users_table
    begin
      self.connection.exec(
        <<~SQL
        CREATE TABLE IF NOT EXISTS users(
          id SERIAL PRIMARY KEY,
          name VARCHAR(20) NOT NULL,
          email VARCHAR(50) UNIQUE NOT NULL,
          password VARCHAR NOT NULL,
          type admin_enum NOT NULL
        );
        SQL
      )
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query for Users Table.'
      puts e.message
    else
      puts "Users Table Created Successfully"  
    end
  end

  def create_tasks_table
    begin
      self.connection.exec(
        <<~SQL
        CREATE TABLE IF NOT EXISTS tasks(
          id SERIAL PRIMARY KEY,
          assignee_user_id INTEGER REFERENCES users(id) NOT NULL,
          description TEXT NOT NULL,
          due_date DATE NOT NULL,
          priority INTEGER NOT NULL,
          creator_id INTEGER REFERENCES users(id) NOT NULL, 
          status status_enum NOT NULL,
          deleted_at DATE 
        );
        SQL
      )
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query for Tasks Table.'
      puts e.message
    else
      puts "Tasks Table Created Successfully"  
    end
  end
end
