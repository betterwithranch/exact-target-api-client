class ExactTarget::Base

  @@deliveries = []

  def self.deliveries
    @@deliveries
  end

  alias __old_queue_triggered_send__ queue_triggered_send
  def queue_triggered_send(message_type, recipient, attributes = {}) 
    result = __old_queue_triggered_send__ message_type, recipient, attributes

    @@deliveries << {
      :message_type => message_type,
      :recipient => recipient,
      :attributes => attributes 
    }

    result
  end
end

