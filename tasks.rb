require './database_setup.rb'


class Task 

  attr_accessor :id, :assignee_user_id, :description, :due_date, :priority, :creator_id, :status 

  def initialize(id, assignee_user_id, description, due_date, priority, creator_id, status)
    self.id=id
    self.assignee_user_id=assignee_user_id
    self.description=description
    self.due_date=due_date
    self.priority=priority
    self.creator_id=creator_id
    self.status=status
  end

  db=DatabaseSetup.new
  def save 
    db.connection.exec_params("INSERT INTO tasks(id, assignee_user_id, description, due_date, priority, creator_id, status) VALUES($1, $2, $3, $4, $5, $6, $7)",[id, assignee_user_id, description, due_date, priority, creator_id, status])
  end
end

