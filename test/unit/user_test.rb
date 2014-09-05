require_relative '../test_helper.rb'
require_relative '../../lib/user.rb'

class UserTest < ActiveSupport::TestCase


  describe User do

    before do
      @user = User.new('token')
      ENV['REPO_ID'] = '23'
    end

    it 'is authorized when have an org that match repo id in enviroment variable' do
      response = [{'id' => 12}, {'id' => 20}, {'id' => 23}]
      HTTParty.stubs(:get).returns(response)
      assert @user.authorized?
    end

    it 'is authorized when have an org that match one of the repo ids in enviroment variable ' do
      ENV['REPO_ID'] = '23,24'
      response = [{'id' => 12}, {'id' => 20}, {'id' => 23}]
      HTTParty.stubs(:get).returns(response)
      assert @user.authorized?
    end

    it 'is not authorized when not having the repo id among his orgs' do
      response = [{'id' => 12}, {'id' => 20}, {'id' => 45}]
      HTTParty.stubs(:get).returns(response)
      assert !@user.authorized?
    end

    it 'is not authorized when the response is nil' do
      HTTParty.stubs(:get).returns(nil)
      assert !@user.authorized?
    end

    it 'is not authorized when the response is empty' do
      HTTParty.stubs(:get).returns('')
      assert !@user.authorized?
    end

    it 'is not authorized when providing bad credentials' do
      HTTParty.stubs(:get).returns([{message:'Bad Credential'}])
      assert !@user.authorized?
    end

    it 'is not authorized when providing awful credentials' do
      HTTParty.stubs(:get).returns({message:'Bad bad'})
      assert !@user.authorized?
    end
  end
end
