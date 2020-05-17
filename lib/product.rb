class Product < Application

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
    @@all << product
    puts "#{product.name} product added to store."
    product
  end

  def self.show(category)
    @@all = Datastore.fetch_records(nil, 'product')
    selected = @@all.select{|p| p.category == category.downcase} if category
    to_table(selected || @@all)
  end

  def self.add_to_cart(id)
    product = find_by_id(id)

    return (p 'Please enter correct product id!!') unless product

    message = if ((qua = product.quantity.to_i) > 0)
                product.quantity = (qua - 1).to_s # decrement the quantity
                Datastore.update_record(product, 'product')
                Cart.active.add_product(product.id, product.price)
                'product added to the cart!'
              else
                'Product out of stock!!'
              end
    p message
  end

  def self.remove_from_cart(id)
    product = find_by_id(id)

    return (p 'Please enter correct product id!!') unless product

    status = Cart.active.remove_product(product.id, product.price)
    message = if status
                qua = product.quantity.to_i
                product.quantity = (qua + 1).to_s # increment the quantity
                Datastore.update_record(product, 'product')
                "\nProduct successfully removed from the cart\n"
              else
                "\nProduct does not exist in cart!\n"
              end
    p message
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

