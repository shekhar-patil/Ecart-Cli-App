class Cart
  extend ECart::Helper
  attr_accessor :user, :products, :total_price, :coupon

  def initialize(user)
    @user         = user
    @products     = []
    @total_price  = 0
    @coupon       = nil
  end

  def show

  end

  def add_coupon(coupon)
    puts "coupon name is #{coupon}"
  end
end

