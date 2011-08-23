require 'spec_helper'

describe ExactTarget::ApiResponseError do
  it 'should populate values from constructor' do
    e = ExactTarget::ApiResponseError.new(:http_error => 'http error', :endpoint => 'endpoint', :request => 'request', :response => 'response')
    e.message.should == <<-msg
      API responded with ERROR

      The http error was "http error".
      The endpoint was "endpoint".
      The request message was "request".
      The response message was "response".

    msg
  end

  it 'should work with no arguments' do
    e = ExactTarget::ApiResponseError.new
    e.message.should == <<-msg
      API responded with ERROR

      The http error was "".
      The endpoint was "".
      The request message was "".
      The response message was "".

    msg
  end
end
