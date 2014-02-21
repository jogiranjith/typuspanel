require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase

  test 'verify typus roles is loaded' do
    assert Typus::Configuration.respond_to?(:roles!)
    assert Typus::Configuration.roles!.kind_of?(Hash)
  end

  test 'verify typus config file is loaded' do
    assert Typus::Configuration.respond_to?(:models!)
    assert Typus::Configuration.models!.kind_of?(Hash)
  end

end
