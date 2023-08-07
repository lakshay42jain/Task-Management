require_relative 'database_connection.rb'
require_relative '../models/task.rb'

class TaskManager
  
  def show_all
    Task.show_all
  end

  def add_task(assignee_email_id:, description:, due_date:, priority:, user:)
    begin
      due_date = Date.parse(due_date)
      assignee_user = User.find_by_email(assignee_email_id)
      if assignee_user.nil?
        puts "Invalid Email Id"
      else  
        Task.new(
          assignee_user: assignee_user.id,
          description: description,
          due_date: due_date,
          priority: priority,
          creator: user.id,
          status: 'pending'
        ).save
      end
    rescue Date::Error => e
      puts "Invalid Date"
    end
  end

  def next_task(user)
    task = Task.next_task(user)
    if task.nil?
      puts "No new Task"
    else
      puts "Task id = #{task.id}, Description = #{task.description}, Due Date = #{task.due_date}"
    end
  end

  def update_status(task_id, new_status)
    task = Task.find_by_id(task_id)
    if task.nil?
      puts "Status not changed due to invalid task id"
    else
      task.status = new_status
      task.save
    end
  end

  def update_priority(task_id, new_priority)
    task = Task.find_by_id(task_id)
    if task.nil?
      puts "Priority not changed due to invalid task id"
    else
      task.priority = new_priority
      task.save
    end
  end

  def postpone(task_id, no_of_days)
    task = Task.find_by_id(task_id)
    if task.nil?
      puts "Invalid Task Id"
    else  
      new_date = task.due_date + no_of_days
      task.due_date = new_date
      task.save
    end
  end

  def delete_by_id(task_id)
    task = Task.find_by_id(task_id)
    if task.nil? 
      puts "Invalid Task id"
    else   
      task.deleted_at = Date.today
      task.save
    end
  end

  def show_all_by_email(email_id)
    user = User.find_by_email(email_id)
    Task.show_all_for_user(user)
  end

  def show_all_for_user(user)
    Task.show_all_for_user(user)
  end
end

