#cart has many product.
class Coupon < Application
  attr_accessor :id, :name, :discount_price, :type, :quantity, :valid_from, :expire_at
  @@all = []

  def initialize(name, discount_per, type, quantity, valid_from, expire_at)
    @id             = rand.to_s
    @name           = name
    @discount_per   = discount_per
    @type           = type
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

  def self.check_validity(id, cart)
    coupon = find_by_id(id)
    return 'Coupon does not exist' unless coupon

    current_user.carts.all.each do |cart|
      if cart.coupon_id.to_s == id.to_s && (cart.coupon_applied_at) && ((Time.parse(cart.coupon_applied_at) + 60*60*4) > Time.now)
        return "Can't use same coupon within 4 hours\nPreviously applied at: #{cart.coupon_applied_at}"
      end
    end
  end
end

