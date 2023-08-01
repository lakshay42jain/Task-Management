require './TableSetup.rb'
# require './main.rb'

class Tasks
  attr_accessor :id, :assignee_user_id, :description, :due_date, :priority, :creator_id, :status 

  def initialize(args = {})
    self.id = args[:id]
    self.assignee_user_id = args[:assignee_user_id]
    self.description = args[:description]
    self.due_date = args[:due_date]
    self.priority = args[:priority]
    self.creator_id = args[:creator_id]
    self.status = args[:status]
  end

  def save 
    begin
      DB_CONNECTION.connection.exec_params("INSERT INTO tasks(id, assignee_user_id, description, due_date, priority, creator_id, status) 
      VALUES($1, $2, $3, $4, $5, $6, $7)", [id, assignee_user_id, description, due_date, priority, creator_id, status])
    rescue PG::InvalidTextRepresentation => e   
      puts "Invalid Represetation (May be status wrong)"
      puts e.message
    rescue PG::SyntaxError => e
      puts 'Error: A syntax error occurred in the SQL query.'
      puts e.message
    rescue PG::ConnectionBad => e
      puts 'Error: The database connection is invalid or closed.'
      puts e.message 
    else
      puts "Task Assign Successfully"
    end
  end
end

