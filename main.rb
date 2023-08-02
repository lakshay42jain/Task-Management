require './table_setup.rb'
require_relative 'services/database_connection.rb'
require_relative 'models/user.rb'
require_relative 'models/task.rb'
require 'date'
require 'bcrypt'

require_relative 'services/task_manager.rb'

#new files
require_relative './application.rb'

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
  assignee_user_id: 2,
  description: "Complete the project (Demo)",
  due_date: Date.new(2023, 8, 15),
  priority: 1,
  creator_id: 1,
  status: "in_progress"
)
t1.save
def assign_task(admin)
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
    assignee_user_id: assignee_user_id,
    description: description,
    due_date: due_date,
    priority: priority, 
    user: admin
  )
end

def delete_task
  connection = DatabaseConnection.connection
  puts "Enter Task id you want to delete"
  delete_id = gets.chomp.to_i
  res = connection.exec("DELETE FROM tasks WHERE id=$1", [delete_id])
  puts "Deleted Sucessfully"
end

Application.boot
