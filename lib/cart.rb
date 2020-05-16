#cart has many product.
class Cart < Application
  attr_accessor :product_ids, :total_price, :coupon_id, :user_id, :id, :status, :coupon_applied_at
  @@all = []
  @@active_cart = nil
  def initialize(user_id)
    @id           = rand.to_s
    @user_id      = user_id
    @product_ids  = []
    @total_price  = 0
    @status       = 'active'
    @coupon_id    = nil
    @coupon_applied_at = nil
  end

  # associations
  has_many :products
  has_one :coupon

  def self.create(user_id)
    cart = Cart.new(user_id)
    Datastore.create_record(cart, 'cart')
    cart
  end

  def add_product(product_id, price)
    product_ids << product_id
    self.total_price = self.total_price + price.to_i
    Datastore.update_record(self, 'cart')
  end

  def remove_product(product_id, price)
    id = product_ids.delete_at(product_ids.index(product_id) || product_ids.length)
    if id == product_id
      self.total_price = self.total_price - price.to_i
      Datastore.update_record(self, 'cart')
      puts 'Successfully removed from the cart\n\n Your updated cart:\n\n'
      Cart.my_cart(self)
    else
      puts 'Product does not exist in cart!'
    end
  end

  def self.add_coupon(coupon_id)
    cart = self.active
    return 'Please remove current coupon_code to apply new code' if cart.coupon

    valid = Coupon.check_validity(coupon_id, cart)
    puts valid if valid != 'no_errors'
  end

  def self.my_cart(cart)
    puts "==================Your Cart====================\n\n"

    return (puts "==============Your cart is empty================\n\n") if cart.products.size == 0

    puts "====================Items=======================\n"
    cart.products.each_with_index do |p, i|
      puts " [#{p.id}] #{i+1})    #{p.name}      #{p.price} Rs.\n"
    end
    puts "================================================\n\n"
    puts "======Total Purchase amount         : #{cart.total_price} Rs.\n"

    applied_dis = 0
    if cart.coupon
      puts "======Coupon discount              : #{cart.coupon.discount_per}%\n"
      applied_dis = cart.total_price * (cart.coupon.discount_per/100)
      puts "======Congratualtions, Applied Discount is #{applied_dis} Rs."
    end

    if !cart.coupon && cart.total_price > 10000
      puts "======Congratualtions, Rs. 500 Discount applied due to purchase of more than 10000"
      applied_dis = 500
    end
    puts "======Final price after discount is : #{cart.total_price - applied_dis} Rs\n\n"
    puts "Tip: Please apply coupon for extra discount\n"         unless cart.coupon
    puts 'Thanks You!!'
  end

  # User.all
  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'cart')
    else
      @@all
    end
  end

  # find active cart for logged In user.
  def self.active
    current_user.carts.select {|c| c.status == 'active'}.first
  end
end

