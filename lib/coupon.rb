#cart has many product.
class Coupon < Application
  attr_accessor :id, :name, :discount_per, :type, :quantity, :valid_from, :expire_at
  @@all = []

  def initialize(name, discount_per, type, quantity, valid_from, expire_at)
    @id             = rand.to_s
    @name           = name
    @discount_per   = discount_per
    @type           = type              # unlimited, one_time, multi_time
    @quantity       = quantity
    @valid_from     = Time.parse(valid_from).to_s
    @expire_at      = Time.parse(expire_at).to_s
  end

  def self.create(name, discount_per, type, quantity, valid_from, expire_at)
    coupon = Coupon.new(name, discount_per, type, quantity, valid_from, expire_at)
    Datastore.create_record(coupon, 'coupon')
    puts to_table([coupon])
  end

  def self.show
    @@all = Datastore.fetch_records(nil, 'coupon')
    to_table(@@all)
  end

  def self.add_coupon(coupon_id)
    cart = Cart.active
    coupon = find_by_id(coupon_id)

    return puts 'Please remove current coupon_code to apply new code' if cart.coupon

    valid = check_validity(coupon, cart)
    return (puts valid) if valid != 'no_errors'

    cart.apply_coupon(coupon_id)

    if coupon.type != 'unlimited'
      coupon.quantity = coupon.quantity - 1
      Datastore.update_record(coupon, 'coupon')
    end

    puts 'Congratulations, Coupon successfully applied!'
  end

  def increase_quantity
    self.quantity += 1
    Datastore.update_record(self, 'coupon')
  end

  def self.check_validity(coupon, cart)
    return 'Coupon does not exist' unless coupon

    current_user.carts.each do |cart|
      if cart.coupon_id.to_s == coupon.id.to_s && (cart.coupon_applied_at) && ((Time.parse(cart.coupon_applied_at) + 60*60*4) > Time.now)
        return "Can't use same coupon within 4 hours\nPreviously applied at: #{cart.coupon_applied_at}"
      end
    end

    if !coupon
      'Coupon does not exist'
    elsif (coupon.type != 'unlimited') && coupon.quantity.to_s == '0'
      'Sorry, Coupon is max out'
    elsif Time.parse(coupon.expire_at.to_s) < Time.now
      'Coupon is expired'
    else
      'no_errors'
    end
  end
end

