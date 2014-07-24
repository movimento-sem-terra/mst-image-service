require_relative '../test_helper.rb'
require_relative '../../lib/flickr.rb'

class Service::FlickrTest < ActiveSupport::TestCase

  setup do
    api = mock()
    api.stubs( :get_access_token ).returns('token')
    api.stubs( :upload_photo).returns('0101')

    info = stub()
    info.stubs(:id).returns('')
    info.stubs(:farm).returns('')
    info.stubs(:server).returns('')
    info.stubs(:secret).returns('')

    api_photos = mock()
    api_photos.stubs( :getInfo ).returns( info )
    api.stubs( :photos ).returns(api_photos)

    @flickr = Service::Flickr.new(api)
  end

  test 'return a json with the thumbnail and link url' do
    FlickRaw.stubs(:url_b).returns('xxx')
    url = @flickr.upload('/var/tmp/010.jpg','010.jpg') #fake file

    assert url.has_key? :thumbnail
    assert url.has_key? :link
  end

  test 'return a json with all links without https' do
    FlickRaw.stubs(:url_b).returns('https://wwww.xxxx.com')
    url = @flickr.upload('/var/tmp/010.jpg','010.jpg') #fake file

    assert_match /http:\/\//, url[:thumbnail]
  end

  test 'return url to static image after upload' do
    expected_url = 'http://flick.service/010.jpg'

    FlickRaw.stubs(:url_b).returns( expected_url )

    url = @flickr.upload('/var/tmp/010.jpg','010.jpg') #fake file

    assert_equal url[:link], expected_url
  end
end
