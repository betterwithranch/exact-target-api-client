module ExactTarget; end

lib_dir = File.join(File.dirname(__FILE__), 'exact-target-api-client')

require File.join(lib_dir, 'base.rb')
require File.join(lib_dir, 'subscriber.rb')
require File.join(lib_dir, 'errors.rb')
