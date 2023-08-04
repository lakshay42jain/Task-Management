require './table_setup.rb'
require_relative 'services/database_connection.rb'
require_relative 'models/user.rb'
require_relative 'models/task.rb'
require 'date'
require 'bcrypt'
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
  assignee_user: 2,
  description: "Complete the project (Demo)",
  due_date: Date.new(2023, 8, 15),
  priority: 1,
  creator: 1,
  status: "in_progress"
)
t1.save
Application.boot
