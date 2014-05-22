require 'httparty'

class User

  def initizalize token
    @token = token
  end

  def authorized?
    response = HTTParty.get('https://oauth.io/api/me', headers: {"Authorization" => "Bearer #{@token}"})
    (response['status'] == 'success')
  end

end
