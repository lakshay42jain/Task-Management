require_relative './spec_helper.rb'

describe Task do 
  before(:each) do
    @admin = User.new(
      name: 'admin Value',
      email: 'admin.value@example.com',
      password: 'password123',
      type: 'admin'
    )
    @admin = @admin.save
  end

  after(:each) do
    DatabaseConnection.clear_tables
  end
  

  describe '.save' do
      it 'creates a new task and assigns an ID' do
        user = User.new(name: 'Dummy Value', email: 'dummy.value@example.com', password: 'password123', type: 'user') 
        user = user.save
        puts user
        new_task = Task.new(
          assignee_user: user.id,
          description: 'Test task description',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'closed'
        )
        expect { new_task.save }.to change { new_task.id }.from(nil)
      end

      it 'updates the task information' do
        user = User.new(
          name: 'Dummy Value', 
          email: 'dummy.value@example.com', 
          password: 'password123', 
          type: 'user'
        ) 
        user = user.save
        existing_task = Task.new(
          assignee_user: user.id,
          description: 'Existing task',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'closed'
        )
        existing_task = existing_task.save
        existing_task.priority = 1
        existing_task.status = 'in_progress'
        existing_task.save
        updated_task = Task.find_by_id(existing_task.id)
        expect(updated_task.priority.to_i).to eq(1)
        expect(updated_task.status).to eq('in_progress')
      end
  end

  describe '.find_by_id' do
      it 'returns the task object' do
        user = User.new(
          name: 'Dummy Value', 
          email: 'dummy.value@example.com', 
          password: 'password123', 
          type: 'user'
        ) 
        user = user.save
        new_task = Task.new(
          assignee_user: user.id,
          description: 'Task to find',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'closed'
        )
        new_task = new_task.save
        found_task = Task.find_by_id(new_task.id)
        expect(found_task).to be_instance_of(Task)
        expect(found_task.id).to eq(new_task.id)
        expect(found_task.description).to eq('Task to find')
      end
  end

  describe '.next_task' do
      it 'returns the highest priority task assigned to the user' do
        user = User.new(
          name: 'Dummy Value', 
          email: 'dummy.value@example.com', 
          password: 'password123', 
          type: 'user'
        ) 
        user = user.save

        task1 = Task.new(
          assignee_user: user.id,
          description: 'High priority task',
          due_date: Date.today,
          priority: 10,
          creator: @admin.id,
          status: 'in_progress'
        )
        task1 = task1.save

        task2 = Task.new(
          assignee_user: user.id,
          description: 'Low priority task',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'in_progress'
        )
        task2 = task2.save

        next_task = Task.next_task(user)
        expect(next_task).to be_instance_of(Task)
        expect(next_task.priority.to_i).to eq(10)
      end
  end

  describe '.show_all' do
      it 'displays the list of tasks' do
        user = User.new(
          name: 'Dummy Value', 
          email: 'dummy.value@example.com', 
          password: 'password123', 
          type: 'user'
        ) 
        user = user.save
        task1 = Task.new(
          assignee_user: user.id,
          description: 'Task 1',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'in_progress'
        )
        task1.save

        task2 = Task.new(
          assignee_user: user.id,
          description: 'Task 2',
          due_date: Date.today,
          priority: 2,
          creator: @admin.id,
          status: 'in_progress'
        )
        task2.save
        expect(Task.show_all).to be_nil
      end
  end

  describe '.show_all_for_user' do
      it 'displays the list of tasks assigned to the user' do
        user = User.new(
          name: 'Dummy Value', 
          email: 'dummy.value@example.com', 
          password: 'password123', 
          type: 'user'
        ) 
        user = user.save

        task1 = Task.new(
          assignee_user: user.id,
          description: 'Task 1',
          due_date: Date.today,
          priority: 1,
          creator: @admin.id,
          status: 'in_progress'
        )
        task1.save
        expect(Task.show_all_for_user(user))
      end
  end
end
