#cart has many product.
class Cart < Application
  attr_accessor :user, :product_ids, :total_price, :coupon, :user_id, :id

  def initialize(user_id)
    @id           = rand.to_s
    @user_id      = user_id
    @product_ids  = []
    @total_price  = 0
    @coupon       = nil
  end

  has_one :user
  has_many :products

  def create_cart(user_id)
    Cart.create(user_id).id
  end

  def self.create(user_id)
    cart = Cart.new(user_id)
    Datastore.create_record(cart, 'cart')
    cart
  end

  def add_to_cart(product_id, price)
    product_ids << product_id
    self.total_price = self.total_price + price.to_i
    binding.pry
    Datastore.create_record(self, 'cart')
  end

  def self.my_cart
    puts "======My Cart========"
    binding.pry
    to_table([current_user.cart])
  end
end

