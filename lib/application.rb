class Application
  require 'time'

  extend ECart::Helper

  # belongs_to association
  def self.belongs_to (resource)

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
end
