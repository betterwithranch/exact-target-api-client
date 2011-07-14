require 'spec_helper'

class EmailUser
  attr_accessor :email, :first_name, :last_name, :zip_code
end

describe ExactTarget::Subscriber do

  let(:user) do 
    u = EmailUser.new
    u.email = 'test@test.com'
    u.first_name = 'First'
    u.last_name = 'Last'
    u.zip_code = '12345'
    u
  end

  describe '#create' do
    it 'should have user profile attributes in soap body' do
      sub = ExactTarget::Subscriber.new

      body = sub.create_body user.email, "First Name" => user.first_name, "Last Name" => user.last_name,
        "Zipcode" => user.zip_code
        

      body['Objects']['EmailAddress'].should == user.email
      body['Objects']['Attributes'][0]['Name'].should == 'First Name'
      body['Objects']['Attributes'][0]['Value'].should == user.first_name
      body['Objects']['Attributes'][1]['Name'].should == 'Last Name'
      body['Objects']['Attributes'][1]['Value'].should == user.last_name
      body['Objects']['Attributes'][2]['Name'].should == 'Zipcode'
      body['Objects']['Attributes'][2]['Value'].should == user.zip_code
    end

    it 'should have master list from config in soap body' do
      sub = ExactTarget::Subscriber.new
      body = sub.create_body(user.email, "First Name" => user.first_name, "Last Name" => user.last_name,
          "Zipcode" => user.zip_code)

      body['Objects']['Lists']['ID'].should == ExactTarget::Base.master_list_id
    end

    it 'should use update or add option' do
      sub = ExactTarget::Subscriber.new

      body = sub.create_body(user.email, "First Name" => user.first_name, "Last Name" => user.last_name,
          "Zipcode" => user.zip_code)

      body['Options']['SaveOptions']['SaveOption']['SaveAction'].should == "UpdateAdd"
      body['Options']['SaveOptions']['SaveOption']['PropertyName'].should == "*"

    end

    it 'should call triggered send after user is added to list' do
      sub = ExactTarget::Subscriber.new
      expected = {"First Name" => user.first_name, "Last Name" => user.last_name, "Zipcode" => user.zip_code}
      sub.should_receive(:send_request).with(sub.create_body(user.email, expected))

      sub.should_receive(:queue_triggered_send).with(:welcome, user.email)
      sub.create(:first_name => user.first_name, :last_name => user.last_name, :zip_code => user.zip_code, :email => user.email)
    end
  end

  describe '#create_client' do
    it 'should use configuration values for wsse credentials' do
      s = ExactTarget::Subscriber.new
      s.create_client.wsse.username.should == ExactTarget::Base.username
      s.create_client.wsse.password.should == ExactTarget::Base.password
    end
  end

  describe '#create', :integration => true do
    it 'should work' do
      WebMock.allow_net_connect!
      ExactTarget::Base.delivery_method = :exact_target

      user.email = 'craig.israel@healthways.com'

      ExactTarget::Subscriber.new.create(:email => user.email, :first_name => user.first_name, :last_name => user.last_name, :zip_code => user.zip_code) 
    end
  end


end
