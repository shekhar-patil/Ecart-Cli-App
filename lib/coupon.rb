#cart has many product.
class Coupon < Application
  attr_accessor :id, :name, :discount_price, :type, :quantity, :start_time, :end_time
  @@all = []

  def initialize(name, discount_per, type, quantity, start_time, end_time)
    @id             = rand.to_s
    @name           = name
    @discount_per   = discount_per
    @type           = type
    @quantity       = quantity
    @start_time     = Time.parse(start_time).to_s
    @end_time       = Time.parse(end_time).to_s
  end

  def self.create(name, discount_per, type, quantity, start_time, end_time)
    coupon = Coupon.new(name, discount_per, type, quantity, start_time, end_time)
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


  end
end

