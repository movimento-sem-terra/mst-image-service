require_relative '../test_helper.rb'
require_relative '../../lib/flickr.rb'

class Service::FlickrTest < ActiveSupport::TestCase

  setup do
    api = mock()
    api.stubs( :get_access_token ).returns('token')
    api.stubs( :upload_photo).returns('0101')

    api_photos = mock()
    api_photos.stubs( :getInfo ).returns( {id:''} )
    api.stubs( :photos ).returns(api_photos)

    @flickr = Service::Flickr.new(api)
  end

  test 'return url to static image after upload' do
    expected_url = 'http://flick.service/010.jpg'

    FlickRaw.stubs(:url_b).returns( expected_url )

    url = @flickr.upload('/var/tmp/010.jpg','010.jpg') #fake file

    assert_equal url, expected_url
  end
end
