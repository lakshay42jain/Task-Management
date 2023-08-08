require 'rspec'
require_relative '../services/database_connection.rb'
require_relative '../models/task.rb'
require_relative '../services/login_service.rb'
require 'simplecov'
require_relative 'spec_helper.rb'

describe Task do 
  let(:test_user) { User.new(id: 1, name: 'Dummy Value', email: 'dummy.value@example.com', password: 'password123', type: 'user') }
  describe '.save' do
    context 'when creating a new task' do
      it 'creates a new task and assigns an ID' do
        new_task = Task.new(
          assignee_user: test_user.id,
          description: 'Test task description',
          due_date: Date.today,
          priority: 1,
          creator: test_user.id,
          status: 'closed'
        )
        expect { new_task.save }.to change { new_task.id }.from(nil)
      end
    end

    context 'when updating an existing task' do
      it 'updates the task information' do
        existing_task = Task.new(
          assignee_user: test_user.id,
          description: 'Existing task',
          due_date: Date.today,
          priority: 1,
          creator: test_user.id,
          status: 'closed'
        )

        existing_task.priority = 1
        existing_task.status = 'in_progress'
        existing_task.save
        updated_task = Task.find_by_id(existing_task.id)
        expect(updated_task.priority.to_i).to eq(1)
        expect(updated_task.status).to eq('in_progress')
      end
    end
  end

  describe '.find_by_id' do
    context 'when a task exists with the given ID' do
      it 'returns the task object' do
        new_task = Task.new(
          assignee_user: test_user.id,
          description: 'Task to find',
          due_date: Date.today,
          priority: 1,
          creator: test_user.id,
          status: 'closed'
        )
        new_task.save
        found_task = Task.find_by_id(new_task.id)
        expect(found_task).to be_instance_of(Task)
        expect(found_task.id).to eq(new_task.id)
        expect(found_task.description).to eq('Task to find')
      end
    end
  end

  describe '.next_task' do
    context 'when there is a task assigned to the user' do
      it 'returns the highest priority task assigned to the user' do
        high_priority_task = Task.new(
          assignee_user: test_user.id,
          description: 'High priority task',
          due_date: Date.today,
          priority: 10,
          creator: test_user.id,
          status: 'in_progress'
        )
        high_priority_task.save

        low_priority_task = Task.new(
          assignee_user: test_user.id,
          description: 'Low priority task',
          due_date: Date.today,
          priority: 1,
          creator: test_user.id,
          status: 'in_progress'
        )
        low_priority_task.save

        next_task = Task.next_task(test_user)
        expect(next_task).to be_instance_of(Task)
        expect(next_task.priority.to_i).to eq(10)
      end
    end
  end

  describe '.show_all' do
    context 'when there are tasks with no deleted_at value' do
      it 'displays the list of tasks' do
        task1 = Task.new(
          assignee_user: test_user.id,
          description: 'Task 1',
          due_date: Date.today,
          priority: 1,
          creator: test_user.id,
          status: 'in_progress'
        )
        task1.save

        task2 = Task.new(
          assignee_user: test_user.id,
          description: 'Task 2',
          due_date: Date.today,
          priority: 2,
          creator: test_user.id,
          status: 'in_progress'
        )
        task2.save
        # expect(Task.show_all).to be_nil
      end
    end
  end
end
