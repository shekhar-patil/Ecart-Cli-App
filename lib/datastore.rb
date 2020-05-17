require 'pry'
require 'pstore'
require './lib/helper'
class Datastore
  extend ECart::Helper

  #this to handle testing of code.
  @database_folder = 'database/' # will change this class variable to test_db while testing
  class << self
    attr_accessor :database_folder # create database_folder class level variable and create getter and setter
  end

  def self.create_record(object, obj_type)
    store = PStore.new("#{self.database_folder}#{obj_type}.pstore")
    store.transaction do
      store[object.id] = object
    end
  end
  self.singleton_class.send(:alias_method, :update_record, :create_record)

  def self.fetch_records(params, obj_type)
    store = PStore.new("#{self.database_folder}#{obj_type}.pstore")
    objects = []
    store.transaction(true) do
      store.roots.each do |obj|
        objects << store[obj]
      end
    end
    objects
  end

  def self.current_user_id
    store = PStore.new("#{self.database_folder}session.pstore")
    store.transaction do
      store['current_user']
    end
  end

  def self.create_session(user_id)
    store = PStore.new("#{self.database_folder}session.pstore")
    store.transaction do
      store['current_user'] = user_id
    end
  end

  def self.delete_session
    store = PStore.new("#{self.database_folder}session.pstore")
    store.transaction do
      store.delete('current_user')
    end
  end

  def self.fetch_resource(id, obj_type)
    load("./lib/#{obj_type.to_s}.rb")
    store = PStore.new("#{self.database_folder}#{obj_type}.pstore")
    store.transaction do
      store[id]
    end
  end
end
