require_relative './spec_helper.rb'

describe User do
    before(:each) do
      DatabaseConnection.clear_tables
      @admin = User.new(
        name: 'Admin Value', 
        email: 'admin.value@example.com', 
        password: 'password123', 
        type: 'admin'
      ) 
      @admin = @admin.save
    end
  
    after(:each) do
      DatabaseConnection.clear_tables
    end

  describe '#save' do
    it 'saves the user and sets the id' do
      user = User.new(
        name: 'Dummy Value', 
        email: 'dummy.value@example.com', 
        password: 'password123', 
        type: 'user'
      ) 
      expect(user.save).to eq(user)
      expect(user.id).not_to be_nil
    end

    it 'does not save if the id is already set' do
      user = User.new(
        id: 1,
        name: 'Dummy Value', 
        email: 'dummy.value@example.com', 
        password: 'password123', 
        type: 'user'
      ) 
      expect(user.save).to be_nil
    end
  end

  describe '.find_by_email' do
    it 'returns the user if email exists' do
      user = User.new(
        name: 'Dummy Value', 
        email: 'dummy.value@example.com', 
        password: 'password123', 
        type: 'user'
      ) 
      user = user.save
      found_user = User.find_by_email('dummy.value@example.com')
      expect(found_user).to be_instance_of(User)
      expect(found_user.email).to eq('dummy.value@example.com')
    end

    it 'returns nil if email does not exist' do
      found_user = User.find_by_email('nonexists@example.com')
      expect(found_user).to be_nil
    end
  end

  describe '#admin?' do
    it 'returns true if the user type is admin' do
      expect(@admin.admin?).to be true
    end

    it 'returns false if the user type is not admin' do
      user = User.new(
        name: 'Dummy Value', 
        email: 'dummy.value@example.com', 
        password: 'password123', 
        type: 'user'
      ) 
      user = user.save
      expect(user.admin?).to be false
    end
  end
end
