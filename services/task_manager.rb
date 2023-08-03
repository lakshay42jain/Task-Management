require_relative 'database_connection.rb'
require_relative '../models/task.rb'

class TaskManager
  @@connection = nil

  def self.connection
    @@connection ||= DatabaseConnection.connection 
  end

  def change_the_status(task_id, new_status)
    Task.find_task(task_id).change_status(new_status)
  end

  def show_all_tasks
    res = TaskManager.connection.exec("SELECT * FROM tasks")
  end

  def add_task(assignee_user_id:, description:, due_date:, priority:, user:)
    user = User.find_by_email(user.email)
    task = Task.create_task(assignee_user_id: assignee_user_id, description: description, due_date: due_date, priority: priority, user: user, status: 'pending') 
    task.save
  end

  def priority_change(task_id, new_priority)
    Task.find_task(task_id).change_priority(new_priority)
  end

  def user_next_task(user)
    Task.next_task(user)
  end

  def delete_task(task_id)
    Task.delete_task(task_id)
  end

  def show_all_tasks
    Task.show_all_tasks
  end

  def postpone_task(task_id, no_of_days)
    Task.find_task(task_id).postpone_task(no_of_days)
  end
end

