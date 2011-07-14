require 'spec_helper'

describe ExactTarget::Subscriber do
  describe '#create' do
    it 'should have user profile attributes in soap body' do
      user = Factory.build(:user)
      sub = ExactTarget::Subscriber.new

      body = sub.create_body(user)

      body['Objects']['EmailAddress'].should == user.email
      body['Objects']['Attributes'][0]['Name'].should == 'First Name'
      body['Objects']['Attributes'][0]['Value'].should == user.profile.first_name
      body['Objects']['Attributes'][1]['Name'].should == 'Last Name'
      body['Objects']['Attributes'][1]['Value'].should == user.profile.last_name
      body['Objects']['Attributes'][2]['Name'].should == 'Zipcode'
      body['Objects']['Attributes'][2]['Value'].should == user.profile.zip_code
    end

    it 'should have master list from config in soap body' do
      user = Factory.build(:user)
      sub = ExactTarget::Subscriber.new
      body = sub.create_body(user)

      body['Objects']['Lists']['ID'].should == ExactTarget::Base.master_list_id
    end

    it 'should use update or add option' do
      user = Factory.build(:user)
      sub = ExactTarget::Subscriber.new

      body = sub.create_body(user)

      body['Options']['SaveOptions']['SaveOption']['SaveAction'].should == "UpdateAdd"
      body['Options']['SaveOptions']['SaveOption']['PropertyName'].should == "*"

    end

    it 'should call triggered send after user is added to list' do
      user = Factory.build(:user)
      sub = ExactTarget::Subscriber.new
      sub.should_receive(:send_request).with(sub.create_body(user))
      sub.should_receive(:queue_triggered_send).with(:welcome, user.email)
      sub.create(user)
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

      user = Factory.build(:user, :email => 'craig.israel@healthways.com')
      ExactTarget::Subscriber.new.create(user)
    end
  end


end
