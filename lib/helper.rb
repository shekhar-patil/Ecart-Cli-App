module ECart
  module Helper
    # convert class name string into underscore name
    def underscore(klass)
      klass.gsub!(/::/, '/')
      klass.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      klass.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      klass.tr!("-", "_")
      klass.downcase!
    end

    # This is dynamic loading of the classes
    def const_missing(c)
      load("./lib/#{underscore(c.to_s)}.rb")
      Object.const_get("#{c.to_s}")
    end

    #convert object into hash
    def to_hash(object)
      hash = {}
      object.instance_variables.each { |var| hash[var.to_s.delete('@')] = object.instance_variable_get(var) }
      hash
    end

    #print array of objects in tabular form
    def to_table(resources)
      h = to_hash(resources.first)
      puts "\n#{h.keys.map{|v| [v]}.transpose.insert(0, h.keys)[1]}\n\n"

      resources.each do |obj|
        h = to_hash(obj)
        puts "#{h.values.map{|v| [v]}.transpose.insert(0, h.keys)[1]}\n"
      end
    end

    def find_by_id(id)
      data_file = self.to_s.downcase
      Datastore.fetch_resource(id, data_file)
    end

    # fetch current login user
    def current_user
      User.current_user
    rescue
      load './lib/user.rb'
      User.current_user
    end
  end
end
