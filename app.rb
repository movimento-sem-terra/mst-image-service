require 'sinatra'
require 'haml'
require 'flickraw'

 
get "/upload" do
  haml :upload
end      

get "/callback/flickr" do
  flickr = FlickRaw::Flickr.new

  request_token = # Retrieve from cache or session etc - see above
  
  oauth_token = params[:oauth_token]
  oauth_verifier = params[:oauth_verifier]

  raw_token = flickr.get_access_token(request_token['oauth_token'], request_token['oauth_token_secret'], oauth_verifier)
  # raw_token is a hash like this {"user_nsid"=>"92023420%40N00", "oauth_token_secret"=>"XXXXXX", "username"=>"boncey", "fullname"=>"Darren%20Greaves", "oauth_token"=>"XXXXXX"}
  # Use URI.unescape on the nsid and name parameters

  oauth_token = raw_token["oauth_token"]
  oauth_token_secret = raw_token["oauth_token_secret"]

  # Store the oauth_token and oauth_token_secret in session or database
  #   and attach to a Flickraw instance before calling any methods requiring authentication

  # Attach the tokens to your flickr instance - you can now make authenticated calls with the flickr object
  flickr.access_token = oauth_token
  flickr.access_secret = oauth_token_secret
end


post "/upload" do 
  path = Dir.mktmpdir('upload')
  name_file = params['myfile'][:filename]
  file_path = "#{path}/#{name_file}" 

  File.open(file_path, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end



  API_KEY='8470765840672f1dbfb95e9dd71e86db'                                                                                           
  SHARED_SECRET='7ee6b8ddc4ea92e1'     
  PHOTO_PATH=file_path

  FlickRaw.api_key=API_KEY
  FlickRaw.shared_secret=SHARED_SECRET

  token = flickr.get_request_token

  verify = '244-946-127'
  token = '72157644364261290-8cda44d84d22bb64'
  secret = 'b2cf1aa63d2f6560'


  begin
    flickr.get_access_token(token, secret, verify)
    login = flickr.test.login
    photo_id = flickr.upload_photo PHOTO_PATH, :title => 'Imagem', :description => 'This is the description'
    
    info = flickr.photos.getInfo(:photo_id => photo_id)
    url = FlickRaw.url_b(info)

    puts "You are now authenticated as #{login.username} with token #{flickr.access_token} and secret #{flickr.access_secret}"
  rescue FlickRaw::FailedResponse => e
    puts "Authentication failed : #{e.msg}"
  end

  return url
end

