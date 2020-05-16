class Product < Application
  extend ECart::Helper

  attr_accessor :id, :category, :name, :price, :quantity
  @@all = []

  def initialize(name, category, price, quantity)
    @id             = rand.to_s
    @name           = name
    @category       = category.downcase
    @price          = price
    @quantity       = quantity
    super
  end

  uniqueness :name

  def self.create(name, category, price, quantity)
    product = Product.new(name, category, price, quantity)
    Datastore.create_record(product, 'product')
    puts "#{product.name} product added to store."
  end

  def self.show(category)
    @@all = Datastore.fetch_records(nil, 'product')
    selected = @@all.select{|p| p.category == category.downcase} if category
    to_table(selected || @@all)
  end

  def self.add_to_cart(id)
    product = find_by_id(id)

    return (puts 'Please enter correct product id!!') unless product

    if ((qua = product.quantity.to_i) > 0)
      product.quantity = (qua - 1).to_s # decrement the quantity
      Datastore.update_record(product, 'product')
      Cart.active.add_product(product.id, product.price)
      puts 'product added!'
    else
      puts 'Product out of stock!!'
    end
  end

  def self.remove_from_cart(id)
    product = find_by_id(id)

    return (puts 'Please enter correct product id!!') unless product

    qua = product.quantity.to_i
    product.quantity = (qua + 1).to_s # increment the quantity
    Datastore.update_record(product, 'product')
    Cart.active.remove_product(product.id, product.price)
    puts 'Product removed!'
  end

  def self.all
    if @@all == []
      @@all = Datastore.fetch_records(nil, 'product')
    else
      @@all
    end
  end

  def self.categories
    Product.all.map {|p| p.category}.uniq.join(', ')
  end
end

