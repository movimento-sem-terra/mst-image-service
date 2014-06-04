require 'httparty'

class User
  ORGS_ENDPOINT = 'https://api.github.com/user/orgs'

  def initialize token
    @token = token
  end

  def authorized?
    response = HTTParty.get(ORGS_ENDPOINT, headers: {
      'Authorization' => "token #{@token}",
      'User-Agent' => 'Application'
    })
    Array(response).flatten.find do |org|
      org['id'].to_s == ENV['REPO_ID'] 
    end
  end

end
