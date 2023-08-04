require_relative 'services/login_service.rb'
require_relative 'services/sign_up_service.rb'
require_relative 'services/task_manager.rb'

class Application
  def self.boot
    @@task_manager = TaskManager.new
    start_event_loop 
  end

  def self.assign_task(user)
    puts 'enter assignee email id'
    assignee_email_id = gets.chomp
    puts 'Enter Description about task'
    description = gets.chomp
    puts 'Enter Task Due date (Format : YYYY/MM/DD)'
    due_date = gets.chomp
    puts 'Enter priority eg: 1, 2, 3'
    priority = gets.chomp
    @@task_manager.add_task(
      assignee_email_id: assignee_email_id,
      description: description,
      due_date: due_date,
      priority: priority, 
      user: user
    )
  end

  def self.delete_task
    puts "Enter email id of user"
    email_id = gets.chomp
    result = @@task_manager.show_all_tasks_by_email(email_id)
    if result.nil?
      puts "No Task Found"
    else   
      puts "Enter task id which you want to delete"
      task_id = gets.chomp.to_i
      @@task_manager.delete_by_id(task_id)
    end
  end

  def self.for_admin(user)
    system('clear')
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
        @@task_manager.show_all_tasks
      when 3
        delete_task
      when 4
        puts("Exiting.......")
        exit
      else
        puts("Invalid Choice. Please Enter a valid choice")    
      end
    end
  end

  def self.update_status(user)
    @@task_manager.show_all_tasks_by_user_id(user.id)
    puts "Enter Task id whose status want to change"
    task_id = gets.chomp.to_i
    puts "Available Statuses: pending, due, in_progress, under_review, closed"
    puts "Enter the new status:"
    new_status = gets.chomp
    @@task_manager.update_status(task_id, new_status)
  end

  def self.update_priority(user)
    @@task_manager.show_all_tasks_by_user_id(user.id)
    puts "Enter task_id "
    task_id = gets.chomp.to_i
    puts "Enter new Priority (Integer)"
    new_priority = gets.chomp.to_i
    @@task_manager.update_priority(task_id, new_priority)
  end
  
  def self.next_task(user)
    @@task_manager.next_task(user)
  end

  def self.task_postpone(user)
    @@task_manager.show_all_tasks_by_user_id(user.id)
    puts "Enter Task id you want to postpone"
    task_id = gets.chomp.to_i
    puts "No of days you want to extend"
    no_of_days = gets.chomp.to_i
    @@task_manager.postpone_task(task_id, no_of_days)
  end

  def self.for_user(user)
    system('clear')
    puts "Welcome User"
    puts "---------------------"
    loop do 
      puts "\nMenu:"
      puts "1. Change Status of Task"
      puts "2. Priority Change"
      puts "3. Next Task For me"
      puts "4. Postpone the Task"
      puts "5. Show All Tasks"
      puts "6. Exit"    
      choice = gets.chomp.to_i 
      case choice
      when 1
        update_status(user)
      when 2 
        update_priority(user)
      when 3 
        next_task(user)
      when 4 
        task_postpone(user)
      when 5
        @@task_manager.show_all_tasks_by_email(user.email)
      when 6  
        puts "Exiting........"
        exit
      else
        puts("Invalid Choice. Please Enter a valid choice")    
      end  
    end
  end

  def self.login
    system('clear')
    email, password = nil
    loop do 
      puts 'Enter Email'
      email = gets.chomp
      break unless email.empty?
    end

    loop do
      puts 'Enter Password'
      password = gets.chomp
      break unless password.empty?
    end

    login = LoginService.new
    user = login.validate(email, password)
    if user.admin?
      for_admin(user)
    else
      for_user(user)
    end
  end
  
  def self.sign_up
    system('clear')
    puts "Enter name"
    name = gets.chomp
    puts "Enter email"
    email = gets.chomp 
    puts "Enter password"
    password = gets.chomp
    sign_up_service = SignupService.new
    sign_up_service.create_user(name, email, password)
  end

  def self.start_event_loop
    system('clear')
    puts "Welcome to Task Management Solution"
    puts "----------------------------------------"
    loop do 
      system('clear')
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
        exit(1)
      else      
        puts ("Invalid Choice. Please Enter a valid choice")
      end
    end
  end
end
