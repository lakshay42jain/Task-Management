require './TableSetup.rb'
require './DatabaseConnection.rb'
require './users.rb'
require './tasks.rb'
require 'date'

DB_CONNECTION = DatabaseConnection.new
table_setup = TableSetup.new(DB_CONNECTION.connection)
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
query_result_for_email = DB_CONNECTION.connection.exec_params("select COUNT(*) from users where email=$1",[email])
query_result_for_pass = DB_CONNECTION.connection.exec_params("SELECT password FROM users WHERE email=$1",[email])

if (query_result_for_email[0]['count'].to_i >= 1 and query_result_for_pass[0]['password'] == password)
  res = DB_CONNECTION.connection.exec_params("SELECT type from users where email=$1",[email])
  if res[0]['type'] == 'admin'
    for_admin(email)
  else
    for_user(email)
  end
else
  puts "Email id does not exist or may be password wrong" 
end
