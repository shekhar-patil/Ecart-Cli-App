module ECart
  module Helper
    # convert class name string into underscore name
    def underscore(klass)
      klass.gsub!(/::/, '/')
      klass.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      klass.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      klass.tr!("-", "_")
      klass.downcase!
      klass
    end
  end
end
