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
      self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
    end
  end

  class UserTask < SubCommandBase

    desc "create", "create docs"
    def create(first_name, last_name, role)
      User.create(first_name, last_name, role)
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
    desc "user", "Create, Update, delete user"
    subcommand "user", UserTask

    desc 'cart', 'show, add coupon'
    subcommand 'cart', CartTask
  end
end
