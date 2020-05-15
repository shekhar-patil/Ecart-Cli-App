require 'pry'
require 'pstore'
require './lib/helper'
class Datastore
  extend ECart::Helper

  def self.create_record(object, obj_type)
    store = PStore.new("#{obj_type}.pstore")
    store.transaction do
      store[object.id] = object
    end
  end
  self.singleton_class.send(:alias_method, :update_record, :create_record)

  def self.fetch_records(params, obj_type)
    store = PStore.new("#{obj_type}.pstore")
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
    store = PStore.new('session.pstore')
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

  def self.fetch_resource(id, obj_type)
    load("./lib/#{obj_type.to_s}.rb")
    store = PStore.new("#{obj_type}.pstore")
    store.transaction do
      store[id]
    end
  end
end
