require 'sinatra'
require 'haml'
require_relative 'lib/flick.rb'
require_relative 'lib/user.rb'
 
get "/upload" do
  haml :upload
end      

post "/upload" do 
  
  token = params['token']
  user  = User.new token

  return "U don't have access bro." if user.authorized?


  path = Dir.mktmpdir('upload')
  name_file = params['myfile'][:filename]
  file_path = "#{path}/#{name_file}" 

  File.open(file_path, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  service = Service::Flickr.new 

  return service.upload file_path
end

