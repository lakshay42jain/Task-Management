require_relative 'services/login_service.rb'
require_relative 'services/sign_up_service.rb'
require_relative 'services/task_manager.rb'

class Application
  @@TaskManager = nil 

  def self.boot
    @@TaskManager = TaskManager.new
    start_event_loop 
  end

  def self.assign_task(user)
    puts 'enter assignee user id'
    assignee_user_id = gets.chomp
    puts 'Enter Description about task'
    description = gets.chomp
    puts 'Enter Due_date Format (YYYY/MM/DD)'
    due_date = gets.chomp
    puts 'Enter priority eg: 1, 2, 3'
    priority = gets.chomp
    puts user.email
    @@TaskManager.add_task(
      assignee_user_id: assignee_user_id,
      description: description,
      due_date: due_date,
      priority: priority, 
      user: user
    )
  end

  def self.delete_task
    puts "Enter Task id you want to delete"
    delete_id = gets.chomp.to_i
    @@TaskManager.delete_task(delete_id)
  end

  def self.for_admin(user)
    puts "Welcome to Admin Panel"
    puts "---------------------------"
    loop do 
      puts "\nMenu:"
      puts "1. Add Task"
      puts "2. Get All tasks"
      puts "3. Delete task"
      puts "4. Exit"
  
      choice = gets.chomp.to_i
  
      case choice
      when 1 
        assign_task(user)
      when 2
        @@TaskManager.show_all_tasks
      when 3
        delete_task
      when 4
        puts("Exiting.......")
        break
      else
        puts("Invalid Choice. Please Enter a valid choice")    
      end
    end
  end

  def self.change_status
    puts "Enter Task id whose status want to change"
    task_id = gets.chomp.to_i
    puts "Available Statuses: pending, due, in progress, under_review, closed"
    puts "Enter the new status:"
    new_status = gets.chomp
    @@TaskManager.change_the_status(task_id,new_status)
  end

  def self.change_priority
    puts "Enter task_id "
    task_id = gets.chomp.to_i
    puts "Enter new Priority (Integer)"
    new_priority = gets.chomp.to_i
    @@TaskManager.priority_change(task_id, new_priority)
    puts "Priority Changed !!"
  end
  
  def self.next_task(user)
    res = @@TaskManager.user_next_task(user)
    puts "Ticket id = #{res.id} and Description = #{res.description}"
  end

  def self.task_postpone
    puts "Enter Task id you want to postpone"
    task_id = gets.chomp.to_i
    puts "No of days you want to extend"
    no_of_days = gets.chomp.to_i
    @@TaskManager.postpone_task(task_id, no_of_days)
  end

  def self.for_user(user)
    puts "Welcome User"
    puts "---------------------"
    loop do 
      puts "\nMenu:"
      puts "1. Change Status of Task"
      puts "2. Priority Change"
      puts "3. Next Task For me"
      puts "4. Postpone the Task"
      puts "4. Exit"
      choice = gets.chomp.to_i 
  
      case choice
      when 1
        change_status
      when 2 
        change_priority
      when 3 
        next_task(user)
      when 4 
        task_postpone  
      when 5
        puts "Exiting........"
        break  
      else
        puts("Invalid Choice. Please Enter a valid choice")    
      end  
    end
  end

  def self.login
    puts 'Enter Email'
    email = gets.chomp
    puts 'Enter Password'
    user_input_password = gets.chomp
    login = LoginService.new
    user = login.validate(email, user_input_password)
    puts user
    if user.type == 'admin'
      for_admin(user)
    else
      for_user(user)
    end
  end
  
  def self.sign_up
    puts "Enter name"
    name = gets.chomp
    puts "Enter email"
    email = gets.chomp 
    puts "Enter password"
    password = gets.chomp
    sign_up = SignupService.new
    sign_up.create_user(name, email, password)
  end

  
  def self.start_event_loop
    puts "Welcome to Task Management Solution"
    puts "----------------------------------------"
    loop do 
      puts "1. Login"
      puts "2. Sign up"
      puts "3. Exit"
      choice = gets.chomp.to_i

      case choice 
      when 1 
        login
      when 2
        sign_up 
      when 3 
        puts "Exiting....."
        break
      else      
        puts ("Invalid Choice. Please Enter a valid choice")
      end
    end
  end
end
