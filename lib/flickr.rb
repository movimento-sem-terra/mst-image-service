require 'flickraw'

module Service
  class Flickr

    def initialize(config)
      @api = setup(config)
    end

    def upload(image_path, file_name)
      begin
        photo_id = @api.upload_photo image_path, :title => file_name, :description => 'File uploaded by cms'
        info = @api.photos.getInfo(:photo_id => photo_id)
        
        large_url = FlickRaw.url_b(info)
        thumbnail_url = FlickRaw.url_t(info)
        medium_url = FlickRaw.url_z(info)
        small_url = FlickRaw.url_n(info)

        links = {link: large_url, thumbnail: thumbnail_url,
         medium: medium_url, small: small_url, title: file_name }

        links.inject({}) do |hash, (key,value)|
          hash[key] = value.gsub('https://','http://')
          hash
        end
      rescue FlickRaw::FailedResponse => e
        "Authentication failed : #{e.msg}"
      end
    end

    private

    def setup
      FlickRaw.api_key =  config['FLICKR_API_KEY']
      FlickRaw.shared_secret = config['FLICKR_SHARED_SECRET']
      api = FlickRaw::Flickr.new
      api.get_access_token config['FLICKR_TOKEN'], config['FLICKR_TOKEN_SECRET'], config['FLICKR_VERIFY_CODE']
      api
    end
  end
end
