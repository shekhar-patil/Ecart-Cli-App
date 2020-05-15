class Session
  extend ECart::Helper
  def self.login(email, password)
    user = User.all.select {|u| (u.email == email && u.password == password)}.first
    if user
      @@current_user = user
      Datastore.create_session(user)
      puts 'Successfully logged In'
    else
      puts 'Invalid login password\nPlease enter correct credentials or create user'
    end
  end

  def self.logout
    User.logout
  end
end

