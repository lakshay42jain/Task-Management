require './users.rb'
require './database_setup.rb'
require './tasks.rb'
require 'date'

db=DatabaseSetup.new
db.setup_database()




=begin  (For Testing Purpose Only)
u1=User.new('chinku','chinku@gmail.com','password','user')
u1.save()

u2=User.new('lakshay','lakshayadmin@gmail.com','password','admin')
u2.save()

task1=Task.new(100,1,"feature sensor add motion also",Date.today+3,1,3,'pending');
task1.save()

=end