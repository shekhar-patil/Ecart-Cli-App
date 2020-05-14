require 'thor'
require 'pry'
require './lib/helper'
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
    desc "show", "create docs"
    def create

    end

    desc "coupons", "user details"
    def details

    end
  end

  class CLI < Thor
    extend Helper
    if current_user
      desc "user", "Create, Update, delete user"
      subcommand "user", UserTask

      desc 'cart', 'show, add coupon'
      subcommand 'cart', CartTask

      desc 'logout', 'logout'
      def logout
        Session.logout
      end
    else
      desc 'user', 'create, Update, delete user'
      subcommand "user", UserTask

      desc 'login', 'Login [EMAIL] [PASSWORD]'
      def login(email, password)
        Session.login(email, password)
      end
    end
  end
end
