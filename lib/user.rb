module ECart
  class User < SubCommandBase

    attr_accessor :first_name, :last_name, :role, :cart

    @@all = []

    # user has first_name, last_name, role
    def initialize(first_name, last_name, role = 'customer')
      @first_name = first_name
      @last_name  = last_name
      @role       = role
      @cart       = Cart.new(self)
      self.class.all << self
    end

    # returns all users. User.all => []
    def self.all
      @@all
    end

    desc "create", "create docs"
    def create
      puts 'hello world'
    end

    desc "publish", "publish docs"
    def publish
      # pubish
    end
  end
end
