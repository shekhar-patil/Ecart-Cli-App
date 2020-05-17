class Application
  require 'time'
  extend ECart::Helper

  def initialize(*args)
    check_uniqueness
  end

  # has_one association
  def self.has_one(resource)
    define_method resource do
      return unless send("#{resource}_id")
      Datastore.fetch_resource(send("#{resource}_id").to_s, resource.to_s)
    end
  end

  # has_many association
  def self.has_many(resource)
    define_method resource do
      resource = resource.to_s.delete_suffix('s')
      objects = []
      send("#{resource}_ids").each do |id|
        objects << Datastore.fetch_resource(id.to_s, resource.to_s)
      end
      objects
    end
  end

  # uniqueness validation
  def self.uniqueness(*args)
    define_method 'check_uniqueness' do
      attributes = args.map(&:to_s)
      self.class.all.each do |resource|
        attributes.each do |attribute|
          if resource.send(attribute).to_s == send(attribute)
            abort(p "Validation Error: #{attribute} is already taken!")
          end
        end
      end
    end
  end
end
