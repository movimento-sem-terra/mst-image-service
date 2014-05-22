require_relative '../test_helper.rb'
require_relative '../../lib/flickr.rb'

class Service::FlickrTest < ActiveSupport::TestCase

  test 'return url to static image after upload' do
    api = mock()
    api.stubs( :get_access_token ).returns('token')
    api.stubs( :upload_photo).returns('0101')

    api_photos = mock()
    api_photos.stubs( :getInfo ).returns( {id:''} )
    api.stubs( :photos ).returns(api_photos)

    expected_url = 'http://flick.service/010.jpg'

    FlickRaw.stubs(:url_b).returns( expected_url )


    flickr = Service::Flickr.new(api)


    url = flickr.upload('/var/tmp/010.jpg') #fake file 

    assert_equal url, expected_url
  end

end
