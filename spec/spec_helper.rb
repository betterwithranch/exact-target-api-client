require 'rubygems'
require 'bundler/setup'

require 'exact-target-api-client'

#Dir['spec/support/**'].each {|f| require File.expand_path(f) }
require 'webmock/rspec'

RSpec.configure do |config|
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    #config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    #config.use_transactional_fixtures = true
    config.filter_run_excluding :integration => true unless config.filter && config.filter[:integration]

end

