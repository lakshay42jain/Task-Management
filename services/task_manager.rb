require_relative 'database_connection.rb'
require_relative '../models/task.rb'

class TaskManager
  def change_the_status(task_id, new_status)
    task = Task.find_task(task_id)
    if task.nil?
      puts "Status not changed due to invalid task id"
    else
      task.change_status(new_status)
    end
  end

  def show_all_tasks
    Task.show_all_tasks
  end

  def add_task(assignee_user_id:, description:, due_date:, priority:, user:)
    user = User.find_by_email(user.email)
    task = Task.create_task(assignee_user_id: assignee_user_id, description: description, due_date: due_date, priority: priority, user: user, status: 'pending') 
    if task.nil?
      puts "Invalid Id"
    else
      task.save
      puts "Task Added !!"
    end
  end

  def priority_change(task_id, new_priority)
    task = Task.find_task(task_id)
    if task.nil?
      puts "Priority not changed due to invalid task id"
    else
      task.change_priority(new_priority)
    end
  end

  def user_next_task(user)
    task = Task.next_task(user)
    if task.nil?
      puts "No new Task"
    else
      task
    end
  end

  def delete_task(task_id)
    task = Task.find_task(task_id)
    if task.nil?
      puts "Not deleted due to invalid task id"
    else
      Task.delete_task(task_id)
    end
  end

  def show_all_tasks
    Task.show_all_tasks
  end

  def postpone_task(task_id, no_of_days)
    task = Task.find_task(task_id)
    if task.nil?
      puts "Invalid Task Id"
    else  
      task.postpone_task(no_of_days)
    end
  end
end

