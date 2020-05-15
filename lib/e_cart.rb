require 'thor'
require 'pry'
require './lib/helper'
load './lib/application.rb'
module ECart
  class Error < StandardError; end

  class SubCommandBase < Thor
    extend Helper
    def self.banner(command, namespace = nil, subcommand = false)
      "#{basename} #{subcommand_prefix} #{command.usage}"
    end

    def self.subcommand_prefix
      self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }.delete_suffix('-task')
    end
  end

  class UserTask < SubCommandBase

    desc "create", "create [FIRST_NAME] [LAST_NAME] [EMAIL] [PASSWORD]"
    def create(first_name, last_name, email, password)
      User.create(first_name, last_name, email, password, role='customer' )
    end

    desc 'show', 'show'
    def show
      User.show
    end

    desc "details", "user details"
    def details
      User.all
    end
  end

  class CartTask < SubCommandBase
    desc "my_cart", "my_cart"
    def my_cart
      Cart.my_cart
    end

    desc "coupons", "user details"
    def details

    end
  end

  class ProductTask < SubCommandBase
    desc 'add', 'add [NAME] [CATEGORY] [PRICE] [QUANTITY]'
    def add_product(name, category='general', price=500, quantity='50')
      Product.create(name, category, price, quantity)
    end

    desc 'show', 'show'
    def show
      Product.show
    end

    desc 'buy', 'buy [PRODUCT_ID]'
    def buy(product_id)
      Product.buy(product_id)
    end
  end

  class CLI < Thor
    extend Helper
    if current_user
      desc "user", "Create, Update, delete user"
      subcommand "user", UserTask

      desc 'cart', 'show, add coupon'
      subcommand 'cart', CartTask

      desc 'product', 'show, add, purchase'
      subcommand 'product', ProductTask

      desc 'logout', 'logout'
      def logout
        Session.logout
      end
      puts "\nLogIn as: #{current_user.first_name} #{current_user.last_name}\n"
    else
      desc 'user', 'create, Update, delete user'
      subcommand "user", UserTask

      desc 'login', 'Login [EMAIL] [PASSWORD]'
      def login(email, password)
        Session.login(email, password)
      end
      puts "Please login or create account to buy the product"
    end
  end
end
