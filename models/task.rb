require_relative '../table_setup.rb'
require_relative '../services/database_connection.rb'
require_relative 'user.rb'

class Task
  @@connection = nil

  def self.connection
    @@connection ||= DatabaseConnection.connection 
  end

  attr_accessor :assignee_user_id, :description, :due_date, :priority, :creator_id, :status, :id

  def initialize(assignee_user_id:, description:, due_date:, priority:, creator_id:, status:, id: nil)
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
      Task.connection.exec_params("INSERT INTO tasks(assignee_user_id, description, due_date, priority, creator_id, status) VALUES($1, $2, $3, $4, $5, $6)", [assignee_user_id, description, due_date, priority, creator_id, status])
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

  def change_status(new_status)
    result = Task.connection.exec_params('UPDATE tasks SET status = $1 WHERE id = $2', [new_status, id]) 
    puts "Status Changed !!"
  end
  
  def change_priority(new_priority)
    Task.connection.exec_params('UPDATE tasks SET priority = $1 WHERE id = $2', [new_priority, id])
    puts "Priority Changed"
  end

  def self.find_task(task_id)
    res = Task.connection.exec_params('SELECT * FROM tasks WHERE id=$1', [task_id])
    if res.ntuples >= 1
      Task.new(
        id: task_id,
        assignee_user_id: res[0]['assignee_user_id'],
        description: res[0]['description'],
        due_date: res[0]['due_date'],
        priority: res[0]['priority'],
        creator_id: res[0]['creator_id'],
        status: res[0]['status']
      )
    else   
      puts "Task Not Found"
    end

  end

  def self.next_task(user)
    result = Task.connection.exec_params("SELECT * FROM tasks WHERE assignee_user_id = $1 ORDER BY priority DESC LIMIT 1", [user.id])
    if result.ntuples >= 1
      Task.new(
        id: result[0]['id'],
        assignee_user_id: result[0]['assignee_user_id'],
        description: result[0]['description'],
        due_date: result[0]['due_date'],
        priority: result[0]['priority'],
        creator_id: result[0]['creator_id'],
        status: result[0]['status']
      )
    else  
      puts "No New Task"
    end  
  end

  def self.delete_task(task_id) 
      result = Task.connection.exec_params("DELETE FROM tasks WHERE id=$1", [task_id])
  end

  def self.create_task(assignee_user_id:, description:, due_date:, priority:, user:, status:)
    formatted_due_date = Date.parse(due_date).strftime('%Y-%m-%d')
    res_user_id = Task.connection.exec_params("SELECT * FROM users WHERE email=$1", [user.email])
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
    result = Task.connection.exec_params("SELECT * FROM tasks")
    result.each do |i|
      puts i 
    end
  end

  def postpone_task(no_of_days)
    result = Task.connection.exec_params("SELECT due_date FROM tasks WHERE id = $1", [id])
    new_date = Date.parse(result[0]["due_date"]) + no_of_days
    result = Task.connection.exec_params("UPDATE tasks SET due_date = $1 WHERE id = $2", [new_date, id])
    puts "Postponed"
  end

end
