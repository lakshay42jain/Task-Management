require './database_connection.rb'

class TaskManager

  def change_status(task_id,new_status)
    task = Task.find_task(task_id)
    Task.change_status(task, new_status)
  end

  def show_all_tasks
    connection = DatabaseConnection.connection
    res = connection.exec("SELECT * FROM tasks")
    for i in res 
      puts i
    end
  end

  def add_task(task_id:, assignee_user_id:, description:, due_date:, priority:, email:,user: )

    connection = DatabaseConnection.connection
    t = Task.new(
      id: task_id,
      assignee_user_id: assignee_user_id,
      description: description,
      due_date: Date.parse(due_date),
      priority: priority,
      creator_id: user.id,
      status: 'pending'
    )
    t.save
  end

  def change_priority(task_id:, new_priority:)
    connection = DatabaseConnection.connection
    connection.exec_params('UPDATE tasks SET priority = $1 WHERE id = $2', [new_priority, task_id])
  end

  def fetch_creator_id(email)
    connection = DatabaseConnection.connection
    res = connection.exec_params("SELECT id FROM users WHERE email = $1", [email])
    puts "id is #{res[0]['id'].to_i}"
    res[0]['id'].to_i
  end
  
  def user_next_task(email)
    connection = DatabaseConnection.connection
    res = connection.exec("SELECT * FROM tasks WHERE assignee_user_id = $1 ORDER BY priority DESC LIMIT 1", [fetch_creator_id(email)])
    res[0]
  end
end

