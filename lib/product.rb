class Product < Application
  extend ECart::Helper

  attr_accessor :id, :category, :name, :price, :quantity
  @@all = []

  def initialize(name, category, price, quantity)
    @id             = rand.to_s
    @name           = name
    @category       = category
    @price          = price
    @quantity       = quantity
  end

  # Associations
  belongs_to 'cart'

  def self.create(name, category, price, quantity)
    product = Product.new(name, category, price, quantity)
    Datastore.create_record(product, 'product')
    puts "#{product.name} product added to store."
  end

  def self.show
    @@all = Datastore.fetch_records(nil, 'product')
    to_table(@@all)
  end

  def self.buy(id)
    product = find_by_id(id)

    return (puts 'Please enter correct product id!!') unless product

    if ((qua = product.quantity.to_i) > 0)
      product.quantity = (qua - 1).to_s # decrement the quantity
      current_user.cart.add_to_cart(product.id, product.price)
    end
  end

  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'product')
    else
      @@all
    end
  end

  def disply_all_categories

  end
end

