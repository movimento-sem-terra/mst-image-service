require 'sinatra'
require 'haml'
require_relative 'lib/flickr.rb'
require_relative 'lib/user.rb'

before do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
    headers['Access-Control-Allow-Credentials'] = 'true'
end

options "*" do
    response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"

    response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
    halt HTTP_STATUS_OK
end

get "/upload" do
  haml :upload
end      

post "/upload" do 
  
  token = params['token'] || ''
  user  = User.new(token)

  return "U don't have access bro." unless user.authorized?

  path = Dir.mktmpdir('upload')
  name_file = params['myfile'][:filename]
  file_path = "#{path}/#{name_file}" 

  File.open(file_path, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  service = Service::Flickr.new 

  return service.upload file_path
end

