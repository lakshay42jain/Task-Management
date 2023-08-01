require './table_setup.rb'
require './database_connection.rb'
require './user.rb'
require './task.rb'
require 'date'
require 'bcrypt'

connection = DatabaseConnection.connection
table_setup = TableSetup.new(connection)
table_setup.setup_database

def for_admin(email)
  puts "Welcome to Admin Panel"
  puts "---------------------------"
end

def for_user(email)
  puts "Welcome User"
  puts "---------------------"
end

puts "Welcome to Task Management Solution"
puts "----------------------------------------"
puts 'Enter Email'
email = gets.chomp
puts 'Enter Password'
password = gets.chomp

query_result_for_email = connection.exec_params("select COUNT(*) from users where email=$1",[email])
query_result_for_pass = connection.exec_params("SELECT password FROM users WHERE email=$1",[email])

if (query_result_for_email[0]['count'].to_i >= 1 and BCrypt::Password.new(query_result_for_pass[0]['password']) == password)
  res = connection.exec_params("SELECT type from users where email=$1",[email])
  if res[0]['type'] == 'admin'
    for_admin(email)
  else
    for_user(email)
  end
else
  puts "Email id does not exist or may be password wrong" 
end
