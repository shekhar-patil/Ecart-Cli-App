module ECart
  class Cart < SubCommandBase

    attr_accessor :user, :products, :total_price, :coupon

    def initialize(user)
      @user         = user
      @products     = []
      @total_price  = 0
      @coupon       = nil
    end

    desc "show", "Show all items in the cart"
    def show

    end

    desc "add_coupon [NAME]", "Add Coupon"
    def add_coupon(coupon)
      puts "coupon name is #{coupon}"
    end
  end
end
