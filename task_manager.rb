require './database_connection.rb'

class TaskManager

  def change_status(task_id, new_status)
    task = Task.find_task(task_id)
    task.change_status(task, new_status)
  end

  def show_all_tasks
    connection = DatabaseConnection.connection
    res = connection.exec("SELECT * FROM tasks")
  end

  def add_task(task_id:, assignee_user_id:, description:, due_date:, priority:, user:)
    connection = DatabaseConnection.connection
    user = User.find_user(user.email)
    task = Task.create_task(id: task_id, assignee_user_id: assignee_user_id, description: description, due_date: due_date, priority: priority, user: user, status: 'pending') 
    task.save
  end

  def change_priority(task_id:, new_priority:)
    task = Task.find_task(task_id)
    Task.change_priority(task,new_priority)
  end

  def user_next_task(user)
    Task.next_task(user)
  end
end

