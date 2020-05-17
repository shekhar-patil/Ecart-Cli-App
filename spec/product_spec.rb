RSpec.describe Product do
  before(:all) do
    @product1 = Product.create('Mango', 'fruit', 120, 100)
    @product2 = Product.create('Apple', 'fruit', 140, 80)
    @product3 = Product.create('TV', 'electronics', 12000, 50)
    @product4 = Product.create('sofa', 'furniture', 8000, 1)
    @user = User.create('test1', 'customer1', 'test@user.com', 'test@123', 'customer')
    Session.login('test@user.com', 'test@123')
  end

  after(:all) do
    Session.logout
  end

  describe 'methods' do
    it 'all' do
      expect(Product.all.include?(@product1)).to be true
      expect(Product.all.include?(@product2)).to be true
    end

    it 'categories' do
      categories = Product.categories.split(', ')
      expect(categories.sort).to eq(['fruit', 'electronics', 'furniture'].sort)
    end

    context 'add_to_cart' do
      it 'wrong product id' do
        expect(Product.add_to_cart('random_product_id')).to eq('Please enter correct product id!!')
      end

      it 'correct product id which is in stock(quantity is one or more)' do
        expect(Product.add_to_cart(@product4.id)).to eq('product added to the cart!')

        # quantity should get decrease by one
        expect(Product.find_by_id(@product4.id).quantity.to_i).to eq(@product4.quantity.to_i - 1)
      end

      it 'try to buy product having zero quantity' do
        expect(Product.find_by_id(@product4.id).quantity.to_i).to be 0

        expect(Product.add_to_cart(@product4.id)).to eq('Product out of stock!!')
      end
    end

    context 'remove_from_cart' do
      it 'try to remove product with wrong product id' do
        expect(Product.remove_from_cart('random_product_id')).to eq('Please enter correct product id!!')
      end

      it 'enter corrent id but product does not exist to the cart' do
        expect(Product.remove_from_cart(@product2.id)).to eq("\nProduct does not exist in cart!\n")

        expect(Product.find_by_id(@product2.id).quantity.to_i).to be (@product2.quantity.to_i)
      end

      it 'removes from cart and quantity increase by one' do
        previous_quantity = Product.find_by_id(@product4.id).quantity.to_i
        expect(Product.remove_from_cart(@product4.id)).to eq("\nProduct successfully removed from the cart\n")

        # quantity should increase by one
        expect(Product.find_by_id(@product4.id).quantity.to_i).to eq(previous_quantity + 1)
      end
    end
  end

  describe 'uniqueness of attribute' do
    it 'has unique name id' do
      begin
        Product.create('Mango', 'fruit', 120, 100)
      rescue SystemExit => e
        expect(e.message).to eq "\nValidation Error: name is already taken!\n"
      end
      expect(Product.all.select {|product| product.name == 'Mango'}.size).to be 1
    end
  end
end
