#cart has many product.
class Cart < Application
  attr_accessor :product_ids, :total_price, :coupon_id, :user_id, :id, :status, :coupon_applied_at, :created_at
  @@all = []

  def initialize(user_id)
    @id           = rand.to_s
    @user_id      = user_id
    @product_ids  = []
    @total_price  = 0
    @status       = 'active'      # active(current cart), checked_out(previous paid carts)
    @coupon_id    = nil
    @coupon_applied_at = nil
    @created_at   = nil
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
      Cart.my_cart(self)
    end
  end

  def apply_coupon(coupon_id)
    self.coupon_id = coupon_id.to_s
    Datastore.update_record(self, 'cart')
  end

  def self.remove_coupon
    cart = Cart.active
    coupon = cart.coupon
    return (puts 'You don\'t have any coupon applied') unless coupon
    puts "You have applied coupon '#{coupon.name}'\nDo you really want to remove it? (y/n)"
    input = STDIN.gets.chomp
    if (['n', 'no'].include?(input.downcase))
      return (puts 'Coupon is not removed')
    end

    cart.coupon_id = nil
    Datastore.update_record(cart, 'cart')
    coupon.increase_quantity
    puts 'Coupon removed'
  end

  def self.checkout
    cart = Cart.active
    return puts 'Cart is empty please add some products' if cart.products.size == 0

    cart.status = 'checked_out'
    cart.coupon_applied_at = Time.now.to_s if cart.coupon
    cart.created_at = Time.now.to_s

    Datastore.update_record(cart, 'cart')
    cart = Cart.create(current_user.id)
    user = current_user
    user.cart_ids << cart.id
    # add new cart to user
    Datastore.update_record(user, 'user')

    puts 'Amount received! Order placed!'
  end

  def self.show_previous_bills
    active_cart_id = Cart.active.id
    current_user.carts.each_with_index do |cart, i|
      next if cart.id == active_cart_id
      puts "\n\n========== Bill No: #{i} | Created_on: #{cart.created_at} ===============\n\n"
      my_cart(cart, true)
    end
  end

  def self.my_cart(cart, previous_bill = false)
    puts "==================Your Cart====================\n\n" unless previous_bill
    return (p "==============Your cart is empty================") if cart.products.size == 0

    puts "\n====================Items=======================\n"
    cart.products.each_with_index do |p, i|
      puts " [#{p.id}] #{i+1})    #{p.name}      #{p.price} Rs.\n"
    end
    puts "================================================\n\n"
    puts "======Total Purchase amount         : #{cart.total_price} Rs.\n"

    applied_dis = 0
    if cart.coupon
      puts "======Applied coupon                : '#{cart.coupon.name}'\n"
      puts "======Coupon discount               : #{cart.coupon.discount_per}%\n"
      applied_dis = cart.total_price.to_i * (cart.coupon.discount_per.to_i/100.0)
      puts "======You have saved                : #{applied_dis} Rs."
    end

    if !cart.coupon && (cart.total_price.to_i > 10000)
      puts "======Congratulations, Rs. 500 Discount applied due to purchase of more than 10000"
      applied_dis = 500
    end
    puts "======Final price after discount is : #{cart.total_price.to_i - applied_dis} Rs\n\n"
    puts "Tip: Please apply coupon for extra discount\n"         unless cart.coupon || previous_bill
    p 'Thanks You!!'
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

