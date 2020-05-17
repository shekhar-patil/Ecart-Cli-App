RSpec.describe Session do
  before(:all) do
    @test_user = User.create('test', 'customer', 'test@user.com', 'test@123', 'customer')
  end

  describe 'methods' do
    context 'login' do
      it 'current_user will return nil if not loggedIn' do
        expect(User.current_user).to be nil
      end

      it 'return current_user after logged In' do
        Session.login('test@user.com', 'test@123')

        expect(User.current_user.first_name).to eq ('test')
        expect(User.current_user.last_name).to eq ('customer')
        expect(User.current_user.email).to eq ('test@user.com')
        expect(User.current_user.role).to eq ('customer')
      end
    end

    context 'logout' do
      it 'should not returns current_user after logout' do
        Session.logout
        expect(User.current_user).to be nil
      end
    end
  end
end
