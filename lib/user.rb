require './lib/helper'
require './lib/datastore'
require 'pstore'

class User
  extend ECart::Helper
  attr_accessor :first_name, :last_name, :role, :cart, :id, :email, :password

  @@all = []
  # user has first_name, last_name, role
  def initialize(first_name, last_name, email, password, role = 'customer')
    @id         = rand
    @first_name = first_name
    @last_name  = last_name
    @password   = password
    @email      = email
    @role       = role
    @cart       = create_cart(@id)
  end

  def create_cart(user_id)
    Cart.create(user_id).id
  end

  def self.create(first_name, last_name, email, password, role)
    user = User.new(first_name, last_name, email, password, role)
    Datastore.create_record(user, 'user')
    puts "Welcome #{user.first_name}!!"
  end

  def self.show
    @@all = Datastore.fetch_records(nil, 'user')
    puts @@all
  end

  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'user')
    else
      @@all
    end
  end

  def self.current_user
    Datastore.current_user
  end
end
