require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require_relative 'user.rb'

class Task
  def self.connection
    @@connection ||= DatabaseConnection.connection 
  end

  private def connection
    @connection ||= Task.connection
  end

  attr_accessor :assignee_user, :description, :due_date, :priority, :creator, :status, :id, :deleted_at

  def initialize(assignee_user:, description:, due_date:, priority:, creator:, status:, id: nil)
    self.deleted_at = nil
    self.id = id
    self.assignee_user = assignee_user
    self.description = description
    self.due_date = due_date
    self.priority = priority
    self.creator = creator
    self.status = status
  end

  def save 
    begin
      if id.nil?
        result = connection.exec_params("INSERT INTO tasks(assignee_user_id, description, due_date, priority, creator_id, status) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *", [assignee_user, description, due_date, priority, creator, status])
        if result.ntuples.nonzero?
          self.id = result[0]['id']
        end 
        puts "Task Assigned Successfully"
        self 
      else
        Task.connection.exec_params("UPDATE tasks SET priority=$1, status=$2, deleted_at=$3, due_date=$4 WHERE id=$5", [priority, status, deleted_at, due_date, id])
        puts "Updated !!" 
      end
    rescue PG::InvalidTextRepresentation => e   
      puts "Invalid Status Entered .... "
      puts e.message
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    rescue ArgumentError => e
      puts "Error parsing due_date: #{e.message}"
    rescue TypeError => e
      puts "Error formatting due_date: #{e.message}"    
    end
  end

  def self.find_by_id(task_id)
    begin 
      result = connection.exec_params("SELECT * FROM tasks WHERE id=$1", [task_id])
      if result.ntuples.zero?
        puts "No Task Found"
      else
        result = result[0].transform_keys(&:to_sym)
        new(
          id: task_id,
          assignee_user: result[:assignee_user_id],
          description: result[:description],
          due_date: Date.parse(result[:due_date]),
          priority: result[:priority],
          creator: result[:creator_id],
          status: result[:status],
        )
      end
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message   
    end
  end

  def self.next_task(user)
    begin
      result = connection.exec_params("SELECT * FROM tasks WHERE assignee_user_id = $1 ORDER BY priority DESC LIMIT 1", [user.id])
      if result.ntuples.zero?
        puts "No Task Found"
      else
        result = result[0].transform_keys(&:to_sym)
        new(
          id: result[:id],
          assignee_user: result[:assignee_user_id],
          description: result[:description],
          due_date: Date.parse(result[:due_date]),
          priority: result[:priority],
          creator: result[:creator_id],
          status: result[:status],
        )
      end
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    end
  end
  
  def self.show_all
    begin
      result = connection.exec_params("SELECT * FROM tasks").to_a
      if result.empty?
        puts "No Task Found"
      else
        puts "-" * 150
        puts sprintf("%-5s%-20s%-40s%-20s%-10s%-20s%-20s%-20s", "ID", "Assignee User", "Description", "Due Date", "Priority", "Status", "Creator", "deleted_at")
        puts "-" * 150
        result.each do |task|
          row = task.transform_keys(&:to_sym)
          puts sprintf("%-5s%-20s%-40s%-20s%-10s%-20s%-20s%-20s", row[:id], row[:assignee_user_id], row[:description], row[:due_date], row[:priority], row[:status], row[:creator_id], row[:deleted_at])
        end
        puts "-" * 150
      end
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    end
  end

  def self.show_all_for_user(user)
    result = connection.exec_params("SELECT * FROM tasks WHERE assignee_user_id=$1 AND deleted_at IS NULL", [user.id]).to_a
    if result.empty?
      puts "No Task Found"
    else
      puts "-" * 150
      puts sprintf("%-5s%-20s%-40s%-20s%-10s%-20s%-20s", "ID", "Assignee User", "Description", "Due Date", "Priority", "Status", "Creator")
      puts "-" * 150
      result.each do |task|
        row = task.transform_keys(&:to_sym)
        puts sprintf("%-5s%-20s%-40s%-20s%-10s%-20s%-20s", row[:id], row[:assignee_user_id], row[:description], row[:due_date], row[:priority], row[:status], row[:creator_id])
      end
      puts "-" * 150
      result
    end
  end
end
