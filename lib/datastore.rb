require 'pry'
require 'pstore'
require './lib/helper'
class Datastore
  extend ECart::Helper
  def self.create_record(object, obj_name)
    store = PStore.new("#{obj_name}.pstore")
    store.transaction do
      store[object.id] = object
    end
  end

  def self.fetch_records(params, obj_name)
    store = PStore.new("#{obj_name}.pstore")
    objects = []
    store.transaction(true) do
      store.roots.each do |obj|
        objects << store[obj]
      end
    end
    objects
  end

  def self.current_user
    store = PStore.new("session.pstore")
    store.transaction do
      store['current_user']
    end
  end

  def self.create_session(user)
    store = PStore.new("session.pstore")
    store.transaction do
      store['current_user'] = user
    end
  end

  def self.delete_session
    store = PStore.new("session.pstore")
    store.transaction do
      store.delete('current_user')
    end
  end
end
