require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require_relative 'user.rb'

class Task
  attr_accessor :assignee_user_id, :description, :due_date, :priority, :creator_id, :status

  def initialize(assignee_user_id:, description:, due_date:, priority:, creator_id:, status:)
    self.assignee_user_id = assignee_user_id
    self.description = description
    self.due_date = due_date
    self.priority = priority
    self.creator_id = creator_id
    self.status = status
  end
  
  def save 
    begin
      connection = DatabaseConnection.connection
      connection.exec_params("INSERT INTO tasks(assignee_user_id, description, due_date, priority, creator_id, status) 
      VALUES($1, $2, $3, $4, $5, $6)", [assignee_user_id, description, due_date, priority, creator_id, status])
    rescue PG::InvalidTextRepresentation => e   
      puts "Invalid Represetation (May be status wrong)"
      puts e.message
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    else
      puts "Task Assign Successfully"
    end
  end

  def self.change_status(task, new_status)
    connection = DatabaseConnection.connection
    connection.exec_params('UPDATE tasks SET status = $1 WHERE id = $2', [new_status, task.id])
  end
  
  def self.change_priority(task, new_priority)
    connection = DatabaseConnection.connection
    connection.exec_params('UPDATE tasks SET priority = $1 WHERE id = $2', [new_priority, task.id])
  end

  def self.find_task(task_id)
    connection = DatabaseConnection.connection
    res = connection.exec_params('SELECT * FROM tasks WHERE id=$1', [task_id])
    return Task.new(
      id: res[0]['id'],
      assignee_user_id: res[0]['assignee_user_id'],
      description: res[0]['description'],
      due_date: res[0]['due_date'],
      priority: res[0]['priority'],
      creator_id: res[0]['creator_id'],
      status: res[0]['status']
    )
  end

  def self.next_task(user)
    connection = DatabaseConnection.connection
    res_user_id = connection.exec_params("SELECT * FROM users WHERE email=$1", [user.email])
    user_id = res_user_id[0]['id']
    res = connection.exec("SELECT * FROM tasks WHERE assignee_user_id = $1 ORDER BY priority DESC LIMIT 1", [user_id])
    return Task.new(
      id: res[0]['id'],
      assignee_user_id: res[0]['assignee_user_id'],
      description: res[0]['description'],
      due_date: res[0]['due_date'],
      priority: res[0]['priority'],
      creator_id: res[0]['creator_id'],
      status: res[0]['status']
    )
  end

  def self.delete_task(task_id)
    connection = DatabaseConnection.connection
    result = connection.exec("DELETE FROM tasks WHERE id=$1", [task_id])
  end

  def self.create_task(assignee_user_id:, description:, due_date:, priority:, user:, status:)
    connection = DatabaseConnection.connection
    formatted_due_date = Date.parse(due_date).strftime('%Y-%m-%d')
    res_user_id = connection.exec_params("SELECT * FROM users WHERE email=$1", [user.email])
    admin_id = res_user_id[0]['id']
    return Task.new(
      assignee_user_id: assignee_user_id,
      description: description,
      due_date: formatted_due_date,
      priority: priority,
      creator_id: admin_id,
      status: status
    )
  end

  def self.show_all_tasks
    connection = DatabaseConnection.connection
    result = connection.exec_params("SELECT * FROM tasks")
    result.each do |i|
      puts i 
    end
  end
end
