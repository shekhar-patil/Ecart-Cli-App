require 'pry'
require 'pstore'
require './lib/helper'
load './lib/cart.rb'
class Datastore
  extend ECart::Helper
  def self.create_record(object, obj_name)
    store = PStore.new("#{obj_name}.pstore")
    store.transaction do
      store[object.first_name] = object
    end
  end

  def self.fetch_records(params, obj_name)
    store = PStore.new("#{obj_name}.pstore")
    objects = []
    store.transaction(true) do
      store.roots.each do |obj|
        objects << to_hash(store[obj])
        #system("echo #{to_hash(store[obj]).values}")
      end
    end
    objects
  end
end
