RSpec.describe User do
  before(:all) do
    @user_customer = User.create('test', 'customer', 'test@customer.com', 'test@123', 'customer')
    @user_admin = User.create('test', 'customer', 'test@admin.com', 'test@123', 'admin')
  end

  describe 'methods' do
    it 'admin?' do
      expect(@user_customer.admin?).to be false
      expect(@user_admin.admin?).to be true
    end

    it 'all' do
      expect(User.all.include?(@user_customer)).to be true
      expect(User.all.include?(@user_admin)).to be true
    end

    it 'current_user' do
      expect(User.current_user).to be nil

      Session.login('test@customer.com', 'test@123')

      expect(User.current_user.first_name).equal? ('test')
      expect(User.current_user.last_name).equal? ('customer')
      expect(User.current_user.email).equal? ('test@customer.com')
      expect(User.current_user.role).equal? ('customer')

      Session.logout
    end
  end

  describe 'association check' do
    it 'has carts' do
      expect(@user_customer.carts.count).to be >= 1
    end

    it 'has only one active cart' do
      expect(@user_customer.carts.select{|cart| cart.status == 'active'}.size).to be 1
    end
  end

  describe 'uniqueness of attribute' do
    it 'has unique email id' do
      begin
        User.create('test', 'customer', 'test@customer.com', 'test@123', 'customer')
      rescue SystemExit => e
        expect(e.message).equal? "\nValidation Error: email is already taken!\n"
      end
      expect(User.all.select {|user| user.email == 'test@customer.com'}.size).to be 1
    end
  end
end
