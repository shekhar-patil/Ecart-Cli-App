class Cart
  extend ECart::Helper
  attr_accessor :user, :products, :total_price, :coupon, :user, :id

  def initialize(user_id)
    @id           = rand
    @user         = user_id
    @products     = []
    @total_price  = 0
    @coupon       = nil
  end

  def create_cart(user_id)
    Cart.create(user_id).id
  end

  def self.create(user_id)
    cart = Cart.new(user_id)
    Datastore.create_record(cart, 'cart')
    cart
  end

  def add_coupon(coupon)
    puts "coupon name is #{coupon}"
  end
end

