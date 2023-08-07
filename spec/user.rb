require_relative '../services/database_connection.rb'
require_relative '../models/user.rb'
require_relative '../services/login_service.rb'

RSpec.describe User do 
  # # let(:fake_connection) { double('connection') }
  # before do
  #   allow(DatabaseConnection).to receive(:connection).and_return(fake_connection)
  # end

  describe '#save' do
    context 'when the user is successfully saved' do
      it 'prints success message' do
        expect(fake_connection).to receive(:exec_params).and_return(nil)
        expect { User.new(name: 'John Doe', email: 'john@example.com', password: 'password123', type: 'user').save }
          .to output("User Created Successfully\n").to_stdout
      end
    end
  end

end
