# User class
class User < Application
  attr_accessor :first_name, :last_name, :role, :cart_ids, :id, :email, :password

  @@all = []
  @@current_user = nil
  # user has first_name, last_name, role
  def initialize(first_name, last_name, email, password, role)
    @id         = rand.to_s
    @first_name = first_name
    @last_name  = last_name
    @password   = password
    @email      = email
    @role       = role
    @cart_ids   = [create_cart(@id)]
    super
  end

  has_many :carts
  uniqueness :email

  def create_cart(user_id)
    Cart.create(user_id).id
  end

  def self.create(first_name, last_name, email, password, role)
    user = User.new(first_name, last_name, email, password, role)
    Datastore.create_record(user, 'user')
    @@all << user
    puts "Welcome #{user.first_name}!!"
  end

  def self.show(user = nil)
    return to_table([current_user]) if user == 'current_user'
    @@all = Datastore.fetch_records(nil, 'user')
    to_table(@@all)
  end

  # User.all
  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'user')
    else
      @@all
    end
  end

  # returns current_user
  def self.current_user
    @@current_user ||= find_by_id(Datastore.current_user_id)
  end

  # logout user
  def self.logout
    Datastore.delete_session
    @@current_user = nil
  end

  # check for admin user
  def admin?
    role == 'admin'
  end
end
