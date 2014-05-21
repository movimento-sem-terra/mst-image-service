
require 'sinatra'
require 'haml'
 
get "/upload" do
  haml :upload
end      

post "/upload" do 
  path = Dir.mktmpdir('upload')
  File.open("#{path}/" + params['myfile'][:filename], "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end
  return "The file was successfully uploaded!"
end

