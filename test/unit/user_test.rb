require_relative '../test_helper.rb'
require_relative '../../lib/user.rb'

class UserTest < ActiveSupport::TestCase


  describe User do

    before do
      config = '{"organizations": [{ "id":"12", "data":  {"flickr":{},"google":{}}}, { "id": "*", "data":{"flickr":"default", "google":"default"}  }]}'
      ENV['CONFIG'] = config
    end

    it 'return a configuration by organization' do
      user = User.new('12')
      result = {flickr:{}, google: {}}

      assert user.enviromment_config, result
    end

    it 'return a default configuration to anyone organization' do
      user = User.new('56')
      result = {flickr:"default", google: "default"}

      assert user.enviromment_config, result
    end

    it 'return a default configuration when a empty org was send' do
      user = User.new(nil)
      result = {flickr:"default", google: "default"}

      assert user.enviromment_config, result
    end

  end
end
