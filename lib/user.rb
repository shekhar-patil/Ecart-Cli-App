require './lib/helper'

class User
  extend ECart::Helper
  attr_accessor :first_name, :last_name, :role, :cart

  @@all = []

  # user has first_name, last_name, role
  def initialize(first_name, last_name, role = 'customer')
    @first_name = first_name
    @last_name  = last_name
    @role       = role
    @cart       = Cart.new(self)
    self.class.all << self
  end

  def self.create(first_name, last_name, role=customer)
    User.new(first_name, last_name, role)
  end

  def self.all
    @@all
  end
end
