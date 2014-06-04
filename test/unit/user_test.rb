require_relative '../test_helper.rb'
require_relative '../../lib/user.rb'
require 'httparty'

class UserTest < ActiveSupport::TestCase
  setup  do
    @token = 'lalalala'
    @user = User.new @token
  end

  test 'should return true when have the repo id inside orgs' do
    response = [{'id' => 12},{'id' => 20},{'id' => 23}]
    HTTParty.stubs(:get).returns(response)
    
    ENV['REPO_ID'] = '23'
    
    assert @user.authorized?
  end

  test 'should return false when do not have the repo id inside orgs' do
    response = [{'id' => 12},{'id' => 20},{'id' => 23}]
    HTTParty.stubs(:get).returns(response)
    
    ENV['REPO_ID'] = '45'
    
    assert !@user.authorized?
  end

  test 'should return false when the response is empty or nil' do
    ENV['REPO_ID'] = '45'

    response = nil
    HTTParty.stubs(:get).returns(response)
    assert !@user.authorized?

    response = ''
    HTTParty.stubs(:get).returns(response)
    assert !@user.authorized?
  end


  test 'should return false when the response is a bad credential' do
    ENV['REPO_ID'] = '45'

    response = [{message:'Bad Credential'}]
    HTTParty.stubs(:get).returns(response)
    assert !@user.authorized?

    response = {message:'Bad bad'}
    HTTParty.stubs(:get).returns(response)
    assert !@user.authorized?
  end
end
