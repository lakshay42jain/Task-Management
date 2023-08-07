require 'bcrypt'
require_relative '../services/login_service.rb'
require_relative '../models/user.rb'
require 'simplecov'
# SimpleCov.start

RSpec.describe LoginService do
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
      user = User.new(email: 'dummy@gmail.com', password: BCrypt::Password.create('dummy_password'), name: 'dummy', type: 'user')
      allow(User).to receive(:find_by_email).and_return(user)

      expect(login_service.validate('dummy@gmail.com', 'dummy_password')).to eq user
    end
  end

end
