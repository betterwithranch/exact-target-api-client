module ExactTarget
  
  @created_subscribers = []

  def self.created_subscribers
    @created_subscribers 
  end

  def self.created_subscribers=(value)
    @created_subscribers = value
  end

  class Subscriber
    alias_method :subscriber_create, :create

    def create(attr = {})
      subscriber_create(attr)
      ExactTarget.created_subscribers << attr
    end

  end

end
