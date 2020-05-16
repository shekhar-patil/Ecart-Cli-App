class Session
  extend ECart::Helper
  def self.login(email, password)
    user = User.all.select {|u| (u.email == email && u.password == password)}.first
    if user
      Datastore.create_session(user.id)
      puts 'Successfully logged In'
    else
      puts "Invalid login email/password\nPlease enter correct credentials or create user"
    end
  end

  def self.logout
    User.logout
  end
end

