class Session < Application

  # login user by email password
  def self.login(email, password)
    user = User.all.select {|u| (u.email == email && u.password == password)}.first
    if user
      Datastore.create_session(user.id)
      puts 'Successfully logged In'
    else
      puts "Invalid login email/password\nPlease enter correct credentials or create user"
    end
  end

  # logout current logged in user
  def self.logout
    User.logout
  end
end

