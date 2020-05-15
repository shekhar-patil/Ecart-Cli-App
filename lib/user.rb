require './lib/helper'
require './lib/datastore'
require 'pstore'

class User < Application
  extend ECart::Helper
  attr_accessor :first_name, :last_name, :role, :cart_id, :id, :email, :password

  @@all = []
  @@current_user = nil
  # user has first_name, last_name, role
  def initialize(first_name, last_name, email, password, role = 'customer')
    @id         = rand.to_s
    @first_name = first_name
    @last_name  = last_name
    @password   = password
    @email      = email
    @role       = role
    @cart_id    = create_cart(@id)
  end

  has_one :cart

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
    to_table(@@all)
  end

  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'user')
    else
      @@all
    end
  end

  def self.current_user
    @@current_user ||= Datastore.current_user
  end

  def self.logout
    Datastore.delete_session
    @@current_user = nil
  end
end
