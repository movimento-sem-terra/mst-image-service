require 'httparty'

class User
  ORGS_ENDPOINT = 'https://api.github.com/user/orgs'

  def initialize token
    @token = token
  end

  def authorized?
    repos = ENV['REPO_ID'].split ','
    response = HTTParty.get(ORGS_ENDPOINT, headers: {
      'Authorization' => "token #{@token}",
      'User-Agent' => 'Application'
    })
    Array(response).flatten.find do |org|
      repos.include? org['id'].to_s
    end
  end

  def enviromment_config
    if authorized?  
      JSON.parse ENV['CONFIG']
    end
  end

end
