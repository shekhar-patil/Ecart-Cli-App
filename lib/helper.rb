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
  end
end
