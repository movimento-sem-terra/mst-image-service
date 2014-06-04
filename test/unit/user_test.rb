require_relative '../test_helper.rb'
require_relative '../../lib/user.rb'

class UserTest < ActiveSupport::TestCase

  setup  do
    ENV['REPO_ID'] = '23'
    @token = 'lalalala'
    @user = User.new @token
  end

  test 'is authorized when having the repo id among his orgs' do
    response = [{'id' => 12}, {'id' => 20}, {'id' => 23}]
    HTTParty.stubs(:get).returns(response)
    assert @user.authorized?
  end

  test 'is not authorized when not having the repo id among his orgs' do
    response = [{'id' => 12}, {'id' => 20}, {'id' => 45}]
    HTTParty.stubs(:get).returns(response)
    assert !@user.authorized?
  end

  test 'is not authorized when the response is nil' do
    HTTParty.stubs(:get).returns(nil)
    assert !@user.authorized?
  end

  test 'is not authorized when the response is empty' do
    HTTParty.stubs(:get).returns('')
    assert !@user.authorized?
  end

  test 'is not authorized when providing bad credentials' do
    HTTParty.stubs(:get).returns([{message:'Bad Credential'}])
    assert !@user.authorized?

    HTTParty.stubs(:get).returns({message:'Bad bad'})
    assert !@user.authorized?
  end

end
