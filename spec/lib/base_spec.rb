require 'spec_helper'
require 'delayed_job'

describe ExactTarget::Base do
  describe '#send_request' do
    let(:response) do
      r = {:create_response => {:results => {:status_code => 'OK'}}}
      r.stub(:success?).and_return(true)
      r
    end

    before :each do
      @delivery_method = ExactTarget::Base.delivery_method
      ExactTarget::Base.delivery_method = :exact_target
    end

    after :each do
      ExactTarget::Base.delivery_method = @delivery_method
    end

    it 'should call web service create with config values' do
      ws_client = Savon::Client.new 
      Savon::Client.stub(:new).and_return(ws_client)

      ws_client.stub(:request).with('CreateRequest', :xmlns => ExactTarget::Base::NS).and_return(response) 

      ExactTarget::Base.new.send_request('')

      ws_client.wsse.username.should == ExactTarget::Base.username
      ws_client.wsse.password.should == ExactTarget::Base.password
    end
  end

  describe '#queue_triggered_send' do
    it 'should build correct soap body for employee welcome message' do

      subscriber = ExactTarget::Base.new
      subscriber.stub(:send_request) { |body| body}

      args={ :registration_url => '/registration',
          :compass_url => '/compass',
          :wba_url => '/wba',
          :quitnet_url => '/quitnet'
      }
      body = subscriber.queue_triggered_send(:employee_welcome, 'test@test.com', args)

      body["Objects"]['TriggeredSendDefinition']['CustomerKey'].should == 'ws_employee_welcome'
      subscribers = body['Objects']['Subscribers']
      subscribers['SubscriberKey'].should == 'test@test.com'
      attributes = subscribers['Attributes']
      attributes[0]['Name'].should == "tr_registration_url"
      attributes[0]['Value'].should == args[:registration_url]
      attributes[1]['Name'].should == 'tr_compass_url'
      attributes[1]['Value'].should == args[:compass_url]
      attributes[2]['Name'].should == 'tr_wba_url'
      attributes[2]['Value'].should == args[:wba_url]
      attributes[3]['Name'].should == 'tr_quitnet_url'
      attributes[3]['Value'].should == args[:quitnet_url]
    end

    it 'should build correct soap body for wba message' do
      subscriber = ExactTarget::Base.new
      subscriber.stub(:send_request) {|body| body}

      args={ :registration_url => '/registration',
          :compass_url => '/compass',
          :wba_url => '/wba',
          :quitnet_url => '/quitnet'
      }
      body = subscriber.queue_triggered_send(:wba, 'test@test.com', args)

      body["Objects"]['TriggeredSendDefinition']['CustomerKey'].should == 'ws_employee_wba'
      subscribers = body['Objects']['Subscribers']
      subscribers['SubscriberKey'].should == 'test@test.com'
      attributes = subscribers['Attributes']
      attributes[0]['Name'].should == "tr_registration_url"
      attributes[0]['Value'].should == args[:registration_url]
      attributes[1]['Name'].should == 'tr_compass_url'
      attributes[1]['Value'].should == args[:compass_url]
      attributes[2]['Name'].should == 'tr_wba_url'
      attributes[2]['Value'].should == args[:wba_url]
      attributes[3]['Name'].should == 'tr_quitnet_url'
      attributes[3]['Value'].should == args[:quitnet_url]
    end

    it 'should build correct soap body for leadership training message' do
      subscriber = ExactTarget::Base.new
      subscriber.stub(:send_request) {|body| body}

      args={ :registration_url => '/registration',
          :leadership_url => '/training'
      }
      body = subscriber.queue_triggered_send(:leadership_invite, 'test@test.com', args)

      body["Objects"]['TriggeredSendDefinition']['CustomerKey'].should == 'ws_employee_leadership'
      subscribers = body['Objects']['Subscribers']
      subscribers['SubscriberKey'].should == 'test@test.com'
      attributes = subscribers['Attributes']
      attributes[0]['Name'].should == "tr_registration_url"
      attributes[0]['Value'].should == args[:registration_url]
      attributes[1]['Name'].should == 'tr_leadership_url'
      attributes[1]['Value'].should == args[:leadership_url]
    end

    it 'should build correct soap body for welcome message' do
      subscriber = ExactTarget::Base.new
      subscriber.stub(:send_request) {|body| body}

      body = subscriber.queue_triggered_send(:welcome, 'test@test.com')

      body["Objects"]['TriggeredSendDefinition']['CustomerKey'].should == '21297'
      subscribers = body['Objects']['Subscribers']
      subscribers['SubscriberKey'].should == 'test@test.com'

    end
  end

  describe '#create_client' do
    it 'should use configuration values for wsse credentials' do
      et = ExactTarget::Base.new
      et.create_client.wsse.username.should == ExactTarget::Base.username
      et.create_client.wsse.password.should == ExactTarget::Base.password
    end
  end
end
