# frozen_string_literal: true

require 'thor'
require 'time'
require 'pry'
require './lib/helper'
require './lib/application.rb'
module ECart
  class Error < StandardError; end

  class SubCommandBase < Thor
    extend Helper
    def self.banner(command, _namespace = nil, _subcommand = false)
      "#{basename} #{subcommand_prefix} #{command.usage}"
    end

    def self.subcommand_prefix
      name.gsub(/.*::/, '').gsub(/^[A-Z]/) { |match| match[0].downcase }.gsub(/[A-Z]/) { |match| "-#{match[0].downcase}" }.delete_suffix('-task')
    end
  end

  class UserTask < SubCommandBase
    desc 'create', 'create [FIRST_NAME] [LAST_NAME] [EMAIL] [PASSWORD]'
    def create(first_name, last_name, email, password, role = 'customer')
      User.create(first_name, last_name, email, password, role)
    end

    desc 'show', 'show'
    def show
      User.show
    end

    desc 'details', 'user details'
    def details
      User.all
    end
  end

  class CartTask < SubCommandBase
    desc 'my_cart', 'my_cart'
    def my_cart
      Cart.my_cart
    end

    desc 'show_coupons', 'show_coupons'
    def show_coupons
      Coupon.show
    end

    desc 'apply_coupon', 'apply_coupons [COUPON_ID]'
    def apply_coupon(coupon_id)
      Cart.add_coupon(coupon_id.to_s)
    end
  end

  class ProductTask < SubCommandBase
    desc 'add', 'add [NAME] [CATEGORY] [PRICE] [QUANTITY]'
    def add_product(name, category = 'general', price = 500, quantity = '50')
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
      desc 'user', 'User related actions'
      subcommand 'user', UserTask

      desc 'cart', 'Cart related actions'
      subcommand 'cart', CartTask

      desc 'product', 'Product related actions'
      subcommand 'product', ProductTask

      desc 'logout', 'logout'
      def logout
        Session.logout
      end

      if current_user.admin?
        desc 'add_coupon', 'add_coupon [NAME] [one_time/multi_time/unlimited] [QUANTITY] ["16/05/2020 12PM"] ["26/05/2020 12PM"]'
        def add_coupon(name, discount_per=10, type='unlimited', quantity=0, start_time=nil, end_time=nil)
          quantity = 1 if type.to_s == 'one_time'
          quantity = 10 if type.to_s == 'multi_time' && quantity == 0
          start_time = Time.now.to_s if start_time == nil
          end_time = (Time.parse(start_time) + 10*60*60*24).to_s if end_time == nil # add 10 days to start_time

          Coupon.create(name, discount_per, type, quantity, start_time, end_time)
        end
      end
      puts "\nLogIn as: #{current_user.first_name} #{current_user.last_name}\n"
    else
      desc 'user', 'User related actions'
      subcommand 'user', UserTask

      desc 'login', 'Login [EMAIL] [PASSWORD]'
      def login(email, password)
        Session.login(email, password)
      end
      puts 'Please login or create account to buy the product'
    end
  end
end
