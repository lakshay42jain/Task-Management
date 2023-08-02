require_relative 'database_connection.rb'
require_relative '../models/task.rb'

class TaskManager

  def change_the_status(task_id, new_status)
    task = Task.find_task(task_id)
    Task.change_status(task, new_status)
  end

  def show_all_tasks
    connection = DatabaseConnection.connection
    res = connection.exec("SELECT * FROM tasks")
  end

  def add_task(assignee_user_id:, description:, due_date:, priority:, user:)
    user = User.find_user(user.email)
    task = Task.create_task(assignee_user_id: assignee_user_id, description: description, due_date: due_date, priority: priority, user: user, status: 'pending') 
    task.save
  end

  def priority_change(task_id, new_priority)
    task = Task.find_task(task_id)
    Task.change_priority(task,new_priority)
  end

  def user_next_task(user)
    Task.next_task(user)
  end

  def delete_task(task_id)
    Task.delete_task(task_id)
    puts "Deleted !!"
  end

  def show_all_tasks
    Task.show_all_tasks
  end
  
  def postpone_task
  end
end

