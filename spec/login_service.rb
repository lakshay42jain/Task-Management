require_relative './spec_helper.rb'

describe LoginService do
  before(:each) do
    DatabaseConnection.clear_tables
  end

  after(:each) do 
    DatabaseConnection.clear_tables
  end

  let(:login_service) { LoginService.new }

  describe '#valid_password?' do
    it 'returns true for a valid password' do
      password_from_db = BCrypt::Password.create('dummy_password')
      user_input_password = 'dummy_password'

      expect(login_service.valid_password?(password_from_db, user_input_password)).to be true
    end
  
    it 'returns false for an invalid password' do
      password_from_db = BCrypt::Password.create('dummy_password')
      user_input_password = 'incorrect_password'
      
      expect(login_service.valid_password?(password_from_db, user_input_password)).to be false
    end
  end

  describe '#validate' do 
    it 'returns the user for valid email and password' do 
      user = User.new(
        name: 'Dummy Value', 
        email: 'dummy.value@example.com', 
        password: 'password123', 
        type: 'user'
      ) 
      user = user.save
      returned_user = login_service.validate('dummy.value@example.com', 'password123')
      expect(returned_user.email).to eq user.email
    end
  end
end
