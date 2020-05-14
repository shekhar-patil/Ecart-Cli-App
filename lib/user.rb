require './lib/helper'
require './lib/datastore'
require 'pstore'

class User
  extend ECart::Helper
  attr_accessor :first_name, :last_name, :role, :cart

  # user has first_name, last_name, role
  def initialize(first_name, last_name, role = 'customer')
    @first_name = first_name
    @last_name  = last_name
    @role       = role
    @cart       = Cart.new(self)
  end

  def self.create(first_name, last_name, role=customer)
    @user = User.new(first_name, last_name, role)
    binding.pry
    Datastore.create_record(@user, 'user')
  end

  def self.show(first_name, last_name)
    @@all = Datastore.fetch_records(nil, 'user')
    puts @@all.first
  end

  def self.all
    @@all
  end
end
