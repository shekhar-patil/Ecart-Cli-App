require "e_cart/version"
require 'pry'
module ECart
  class Error < StandardError; end
  class CLI < Thor
    desc "hello world", "my first cli yay"
    def hello
      puts "Hello world"
    end
  end
end
