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
    if !current_user
      desc 'create', 'create [FIRST_NAME]* [LAST_NAME]* [EMAIL]* [PASSWORD]* (please use string space separated)'
      def create(first_name, last_name, email, password, role = 'customer')
        User.create(first_name, last_name, email, password, role)
      end
    end

    if current_user
      # only login user can see details
      desc 'details', 'user details'
      def details
        puts current_user
      end

      # Only admin can see all users
      if current_user.admin?
        desc 'show', 'show'
        def show
          User.show
        end
      end
    end
  end

  class CartTask < SubCommandBase
    desc 'my_cart', 'my_cart'
    def my_cart
      Cart.my_cart(Cart.active)
    end

    desc 'show_coupons', 'show_coupons'
    def show_coupons
      Coupon.show
    end

    desc 'apply_coupon', 'apply_coupons [COUPON_ID]*'
    def apply_coupon(coupon_id)
      Cart.add_coupon(coupon_id.to_s)
    end
  end

  class ProductTask < SubCommandBase

    # only admin can add the product
    if current_user && current_user.admin?
      desc 'create', 'create [NAME]* [CATEGORY] [PRICE] [QUANTITY]'
      def create(name, category = 'general', price = 500, quantity = '50')
        Product.create(name, category, price, quantity)
      end
    end

    desc 'show', 'show [category]'
    def show(category=nil)
      Product.show(category)
    end

    desc 'add_to_cart', 'add_to_cart [PRODUCT_ID]*'
    def add_to_cart(product_id)
      Product.add_to_cart(product_id)
    end

    desc 'remove_from_cart', 'remove_from_cart [PRODUCT_ID]*'
    def remove_from_cart(product_id)
      Product.remove_from_cart(product_id)
    end

    desc 'categories', 'categories'
    def catergories
      puts "All product categories are as the following:\n\n"
      puts Product.categories
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
        desc 'add_coupon', 'add_coupon [NAME]* [one_time/multi_time/unlimited] [QUANTITY] ["16/05/2020 12PM"] ["26/05/2020 12PM"]'
        def add_coupon(name, discount_per=10, type='unlimited', quantity=0, valid_from=nil, expire_at=nil)
          quantity = 1 if type.to_s == 'one_time'
          quantity = 10 if type.to_s == 'multi_time' && quantity == 0
          valid_from = Time.now.to_s if valid_from == nil
          expire_at = (Time.parse(valid_from) + 10*60*60*24).to_s if expire_at == nil # will expire after 10 days of valid_from

          Coupon.create(name, discount_per, type, quantity, valid_from, expire_at)
        end
      end

      puts "LogIn as: #{current_user.first_name} #{current_user.last_name}\n\n"
      puts "Role    : Admin\n\n" if current_user.admin?
    else
      desc 'user', 'User related actions'
      subcommand 'user', UserTask

      desc 'login', 'Login [EMAIL]* [PASSWORD]*'
      def login(email, password)
        Session.login(email, password)
      end

      puts 'Please login or create account to buy the product'
    end
  end
end
