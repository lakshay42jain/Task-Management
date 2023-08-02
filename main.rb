require './table_setup.rb'
require './database_connection.rb'
require './user.rb'
require './task.rb'
require 'date'
require 'bcrypt'
require './login.rb'
require './sign_up.rb'
require './task_manager.rb'

connection = DatabaseConnection.connection
table_setup = TableSetup.new(connection)
table_setup.setup_database
u1 = User.new(
  name: 'lakshay',
  email: 'lakshay@gmail.com',
  password: 'password',
  type: 'admin'
)
u1.save
u2 = User.new(
  name: 'chinku',
  email: 'chinku@gmail.com',
  password: 'password',
  type: 'user'
)
u2.save
t1 = Task.new(
  id: 1,
  assignee_user_id: 2,
  description: "Complete the project (Demo)",
  due_date: Date.new(2023, 8, 15),
  priority: 1,
  creator_id: 1,
  status: "in_progress"
)
t1.save
def assign_task(user)
  puts 'enter task id (ticket id)'
  task_id = gets.chomp
  puts 'enter assignee user id'
  assignee_user_id = gets.chomp
  puts 'Enter Description about task'
  description = gets.chomp
  puts 'Enter Due_date Format (DD//MM//YYYY)'
  due_date = gets.chomp
  puts 'Enter priority eg: 1, 2, 3'
  priority = gets.chomp
  tm = TaskManager.new
  tm.add_task(
    task_id: task_id, 
    assignee_user_id: assignee_user_id,
    description: description,
    due_date: due_date,
    priority: priority, 
    email: email,
    user: user
  )
end

def delete_task
  connection = DatabaseConnection.connection
  puts "Enter Task id you want to delete"
  delete_id = gets.chomp.to_i
  res = connection.exec("DELETE FROM tasks WHERE id=$1", [delete_id])
  puts "Deleted Sucessfully"
end

def for_admin(user)
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
      tm = TaskManager.new
      tm.show_all_tasks
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

def change_status
  puts "Enter Task id whose status want to change"
  task_id = gets.chomp.to_i
  puts "Available Statuses: pending, due, in progress, under_review, closed"
  puts "Enter the new status:"
  new_status = gets.chomp
  tm = TaskManager.new
  tm.change_status(task_id,new_status)
  puts "Status Changed !!"
end

def change_priority
  puts "Enter task_id "
  task_id = gets.chomp.to_i
  puts "Enter new Priority (Integer)"
  new_priority = gets.chomp.to_i
  tm = TaskManager.new  
  tm.change_priority(
    task_id: task_id,
    new_priority: new_priority
  )  
  puts "Priority Changed !!"
end

def next_task(user)
  tm = TaskManager.new
  res = tm.user_next_task(email)
  puts res
end

def for_user(user)
  puts "Welcome User"
  puts "---------------------"
  loop do 
    puts "\nMenu:"
    puts "1. Change Status of Task"
    puts "2. Priority Change"
    puts "3. Next Task For me"
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
      puts "Exiting........"
      break  
    else
      puts("Invalid Choice. Please Enter a valid choice")    
    end  
  end
end



def login
  puts 'Enter Email'
  email = gets.chomp
  puts 'Enter Password'
  user_input_password = gets.chomp
  login = Login.new
  user = login.validate(email, user_input_password)
  if user.type == 'admin'
    for_admin(user)
  else
    for_user(user)
  end
end

def sign_up
  puts "Enter name"
  name = gets.chomp
  puts "Enter email"
  email = gets.chomp 
  puts "Enter password"
  password = gets.chomp
  sign_up = Signup.new
  sign_up.create_user(name, email, password)
end

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

