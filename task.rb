require './table_setup.rb'
require './database_connection.rb'

class Task
  attr_accessor :id, :assignee_user_id, :description, :due_date, :priority, :creator_id, :status

  def initialize(id:, assignee_user_id:, description:, due_date:, priority:, creator_id:, status:)
    self.id = id
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
      connection.exec_params("INSERT INTO tasks(id, assignee_user_id, description, due_date, priority, creator_id, status) 
      VALUES($1, $2, $3, $4, $5, $6, $7)", [id, assignee_user_id, description, due_date, priority, creator_id, status])
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
    connection.exec_params('UPDATE tasks SET status = $1 WHERE id = $2', [new_status,task.id])
  end
  
  def self.find_task(task_id)
    connection = DatabaseConnection.connection
    res=connection.exec_params('SELECT * FROM tasks WHERE id=$1',[task_id])
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


end
