require 'flickraw'

module Service
  class Flickr 
    
    API_KEY = ENV['FLICKR_API_KEY'] 
    VERIFY_CODE = ENV['FLICKR_VERIFY_CODE']
    TOKEN = ENV['FLICKR_TOKEN']
    TOKEN_SECRET = ENV['FLICKR_TOKEN_SECRET']
    SHARED_SECRET = ENV['FLICKR_SHARED_SECRET']

    def initialize(api=nil)
      @api = api || api_service
      @api.get_access_token(TOKEN, TOKEN_SECRET, VERIFY_CODE)
    end

    def upload(image_path)
      begin
        photo_id = @api.upload_photo image_path, :title => 'Imagem', :description => 'This is the description'
        info = @api.photos.getInfo(:photo_id => photo_id)
        FlickRaw.url_b(info)

      rescue FlickRaw::FailedResponse => e
        "Authentication failed : #{e.msg}"
      end
    end

    private

    def api_service
      FlickRaw.api_key = API_KEY
      FlickRaw.shared_secret = SHARED_SECRET
      FlickRaw::Flickr.new
    end
  end
end
