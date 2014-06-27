require 'flickraw'

module Service
  class Flickr

    #app info
    API_KEY = ENV['FLICKR_API_KEY']
    SHARED_SECRET = ENV['FLICKR_SHARED_SECRET']

    #user info
    TOKEN = ENV['FLICKR_TOKEN']
    TOKEN_SECRET = ENV['FLICKR_TOKEN_SECRET']
    VERIFY_CODE = ENV['FLICKR_VERIFY_CODE']

    def initialize(api=nil)
      @api = api || api_service
      @api.get_access_token(TOKEN, TOKEN_SECRET, VERIFY_CODE)
    end

    def upload(image_path, file_name)
      begin
        photo_id = @api.upload_photo image_path, :title => 'Imagem', :description => 'This is the description'
        info = @api.photos.getInfo(:photo_id => photo_id)
        large_url = FlickRaw.url_b(info)
        thumbnail_url = FlickRaw.url_t(info)
        medium_url = FlickRaw.url_z(info)
        small_url = FlickRaw.url_n(info)

        {link: large_url, thumbnail: thumbnail_url,
         medium: medium_url, small: small_url }

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
