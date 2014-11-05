class User

  def initialize organization
    @organization = organization
    @config = JSON.parse ENV['CONFIG']
  end

  def enviromment_config
    result = @config["organizations"].find do |org|
      org["id"] == @organization
    end
    unless result
      result = @config["organizations"].find do |org|
        org["id"] == "*"
      end
    end
    result["data"]
  end
end
