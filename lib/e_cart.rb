require 'thor'
require 'pry'
require './lib/helper'
module ECart
  class Error < StandardError; end

  class SubCommandBase < Thor
    def self.banner(command, namespace = nil, subcommand = false)
      "#{basename} #{subcommand_prefix} #{command.usage}"
    end

    def self.subcommand_prefix
      self.name.gsub(%r{.*::}, '').gsub(%r{^[A-Z]}) { |match| match[0].downcase }.gsub(%r{[A-Z]}) { |match| "-#{match[0].downcase}" }
    end
  end

  class CLI < Thor
    extend Helper
    # This is dynamic loading of the classes
    def self.const_missing(c)
      load("./lib/#{CLI.underscore(c.to_s)}")
      Object.const_get(c)
    end

    desc "user", "Create, Update, delete user"
    subcommand "user", User

    desc 'cart', 'show, add coupon'
    subcommand 'cart', Cart
  end
end
