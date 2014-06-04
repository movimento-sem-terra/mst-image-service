require 'httparty'

class User

  def initialize token
    @token = token
  end

  def authorized?
    response = HTTParty.get('https://api.github.com/user/orgs', headers: {"Authorization" => "token #{@token}",
                                                                          "User-Agent" => 'Application' })

    unless response.to_s.empty?
      values = Array(response).flatten
      (not values.index { |org| org['id'].to_s == ENV['REPO_ID'] }.nil?)
    else
      false
    end
  end

end
