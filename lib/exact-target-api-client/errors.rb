class ExactTarget::ApiResponseError < StandardError
  attr_accessor :http_error, :endpoint, :request, :response 

  def initialize(attr={})
    super <<-msg
      API responded with ERROR

      The http error was "#{attr.delete(:http_error)}".
      The endpoint was "#{attr.delete(:endpoint)}".
      The request message was "#{attr.delete(:request)}".
      The response message was "#{attr.delete(:response)}".

    msg
  end
    
end
