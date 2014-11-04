require 'sinatra'
require 'sinatra/json'
require 'mime-types'
require 'json'

require_relative 'lib/flickr.rb'
require_relative 'lib/user.rb'
require_relative 'lib/google_drive.rb'

before do
  headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
  headers['Access-Control-Allow-Origin'] = '*'
  headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin, content-type'
  headers['Access-Control-Allow-Credentials'] = 'true'
end

options "*" do
  response.headers["Allow"] = "HEAD,GET,PUT,DELETE,OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
  halt HTTP_STATUS_OK
end

get "/upload" do
  require 'haml'
  haml :upload
end


   
post "/upload" do
  begin
    token = params['token'] || ''
    user  = User.new(token)

    token = JSON.parse ENV['MST']
  #  return "U don't have access bro. - #{token}" unless user.authorized?

    path = Dir.mktmpdir('upload')
    file_name = params['myfile'][:filename]
    file_path = "#{path}/#{file_name}"


    File.open(file_path, "w") do |f|
      f.write(params['myfile'][:tempfile].read)
    end
    is_image = (MIME::Types.of(file_name).first.media_type == 'image')


    service =  is_image ? Service::Flickr.new : Service::GoogleDrive.new

    json(service.upload(file_path, file_name))
  rescue Exception => e
    return e.message
  end
end

get "/files" do
  service = Service::GoogleDrive.new
  @files = service.list
  haml :files
end
