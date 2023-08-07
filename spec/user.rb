require_relative '../services/database_connection.rb'
require_relative '../models/user.rb'
require_relative '../services/login_service.rb'

RSpec.describe User do 
  # # let(:fake_connection) { double('connection') }
  # before do
  #   allow(DatabaseConnection).to receive(:connection).and_return(fake_connection)
  # end

  describe '#initialize' do
    it 'assigns the attributes correctly' do
      user = User.new(name: 'Dummy', email: 'dummy@gmail.com', password: 'password', type: 'user')
      expect(user.name).to eq('Dummy')
      expect(user.email).to eq('dummy@gmail.com')
      expect(user.password).to eq('password')
      expect(user.type).to eq('user')
      expect(user.id).to be_nil
    end
  end


  describe '#save' do
    context 'when the user does not exist' do
      it 'creates a new user and prints success message' do
        allow(User).to receive(:find_by_email).and_return(nil)
        user = User.new(name: 'Dummy', email: 'dummy@gmail.com', password: 'password', type: 'user')
        expect { user.save }.to output("User Created Successfully\n").to_stdout
      end
    end
  end
end
