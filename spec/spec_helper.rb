require 'spec'
require 'acts_as_fu'
require File.join(File.dirname(__FILE__), '..', 'lib', 'active_model_listener')

Spec::Runner.configure do |config|
  config.include ActsAsFu
end
