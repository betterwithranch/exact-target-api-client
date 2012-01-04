require 'savon'

class ExactTarget::Base 

  NS = 'http://exacttarget.com/wsdl/partnerAPI'

  class << self
    attr_accessor :delivery_method, :username, :password, :master_list_id
    def config
      yield self if block_given?
    end

    def restore_configuration_defaults
      self.master_list_id = '5507320'
    end

    def send_definitions
      @send_definitions ||= {}
    end
  end

  restore_configuration_defaults

  def delivery_method
    @delivery_method = ExactTarget::Base.delivery_method || :exact_target
  end

  def test_mode?
    delivery_method == :test
  end

  def send_request(body)
    return if test_mode?

    response = client.request "CreateRequest", :xmlns => NS do 
      http.headers['SOAPAction'] = 'Create'
      soap.body = body
    end

    unless response.success? && response.to_hash[:create_response][:results][:status_code].downcase == 'ok'
      raise ExactTarget::ApiResponseError.new(:http_error => response.http_error,
          :endpoint => client.soap.endpoint, 
          :request  => client.soap.to_xml,
          :response => response.to_xml)
    end
  end

  def client
    @client ||= create_client
  end

  def create_client
    c = Savon::Client.new do
      wsdl.endpoint = "https://webservice.exacttarget.com/Service.asmx"
      wsdl.namespace = NS
      http.auth.ssl.verify_mode = :none
    end

    c.wsse.credentials ExactTarget::Base.username, ExactTarget::Base.password
    c
  end

  def build_attribute(name, value)
    {"Name" => name, "Value" => value}
  end

  def build_attributes(attr)
    attr.map {|k,v| build_attribute(k,v)}
  end

  def queue_triggered_send(message_type, recipient, attributes = {}) 
    body_attributes = attributes.collect {|k,v| build_attribute("tr_#{k}", v)}

    body = {"Objects" => {
                  "TriggeredSendDefinition" => {
                    "CustomerKey" => ExactTarget::Base.send_definitions[message_type]
                  },
                  "Subscribers" => {
                    "SubscriberKey" => recipient,
                    "EmailAddress" => recipient,
                    "Attributes" => body_attributes
                  }
                },
         :attributes! => {
          "Objects" => {"xsi:type" => "TriggeredSend"}
         }
    }

    send_request(body)
  end

end
