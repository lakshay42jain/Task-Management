require 'rspec'
require_relative '../models/user'  # Assuming your User class is in a separate 'user.rb' file
require_relative '../services/database_connection.rb'
require 'simplecov'
require_relative 'spec_helper.rb'

describe User do
  let(:name) { 'Dummy Value' }
  let(:email) { 'dummy.value@example.com' }
  let(:password) { 'password123' }
  let(:type) { 'user' }

  describe '#save' do
    it 'saves the user and sets the id' do
      user = User.new(name: name, email: 'email@1233', password: password, type: type)
      expect(user.save).to eq(user)
      expect(user.id).not_to be_nil
    end

    it 'does not save if the id is already set' do
      user = User.new(name: name, email: email, password: password, type: type, id: 1)
      expect(user.save).to be_nil
    end
  end

  describe '.find_by_email' do
    it 'returns the user if email exists' do
    
      found_user = User.find_by_email(email)
      expect(found_user).to be_a(User)
      expect(found_user.email).to eq(email)
    end

    it 'returns nil if email does not exist' do
      found_user = User.find_by_email('nonexists@example.com')
      expect(found_user).to be_nil
    end
  end

  describe '#admin?' do
    it 'returns true if the user type is admin' do
      user = User.new(name: name, email: email, password: password, type: 'admin')
      expect(user.admin?).to be true
    end

    it 'returns false if the user type is not admin' do
      user = User.new(name: name, email: email, password: password, type: 'regular')
      expect(user.admin?).to be false
    end
  end
end
