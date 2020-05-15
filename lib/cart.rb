#cart has many product.
class Cart < Application
  attr_accessor :product_ids, :total_price, :coupon_id, :user_id, :id, :coupon_applied_at

  def initialize(user_id)
    @id           = rand.to_s
    @user_id      = user_id
    @product_ids  = []
    @total_price  = 0
    @coupon_id    = nil
    @coupon_applied_at = nil
  end

  # associations
  belongs_to :user
  has_many :products
  has_one :coupon

  def self.create(user_id)
    cart = Cart.new(user_id)
    Datastore.create_record(cart, 'cart')
    cart
  end

  def add_to_cart(product_id, price)
    product_ids << product_id
    self.total_price = self.total_price + price.to_i
    Datastore.create_record(self, 'cart')
  end

  def self.add_coupon(coupon_id)
    cart = current_user.cart
    valid = Coupon.check_validity(coupon_id, cart)
    puts valid if valid != 'no_errors'
  end

  def self.my_cart
    puts "======Your Cart========\n\n"
    cart = current_user.cart
    puts "========Items========\n"
    cart.products.each_with_index do |p, i|
      puts " #{i+1})     #{p.name}      #{p.price}Rs \n"
    end
    puts "=====================\n\n"
    puts "======Total Purchase amount         : #{cart.total_price}\n"

    applied_dis = 0
    if cart.coupon
      puts "======Coupon discount              : #{cart.coupon.discount_per}%\n"
      applied_dis = cart.total_price * (cart.coupon.discount_per/100)
      puts "======Congratualtions, Applied Discount is #{applied_dis}"
    end

    if !cart.coupon && cart.total_price > 1000
      puts "======Congratualtions, Rs. 50 Discount applied due to purchase of more than 1000"
      applied_dis = 50
    end
    puts "======Final price after discount is : #{cart.total_price - applied_dis}\n\n"
    puts "Tip: Please apply coupon for extra discount\n"         unless cart.coupon
    puts 'Thanks You!!'
  end
end

