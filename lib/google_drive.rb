require 'rubygems'
require 'google/api_client'
require 'launchy'

module Service
  class GoogleDrive

    def initialize(api=nil)
      @api = api || api_service
      @drive = @drive || @api.discovered_api('drive', 'v2')
    end

    def upload(file_path)
      begin
      	file = @drive.files.insert.request_schema.new({
      		'title' => 'new_test.pdf',
      		'description' => 'dummy test file'
      		})

    # Set the parent folder.
    #  if parent_id
    #    file.parents = [{'id' => parent_id}]
    #  end

      	media = Google::APIClient::UploadIO.new(file_path, 'application/pdf')
      	result = @api.execute(
      		:api_method => @drive.files.insert,
      		:body_object => file,
      		:media => media,
      		:parameters => {
      			'uploadType' => 'multipart '})

		    result.data.downloadUrl
      end
    end

  def retrieve_all_files()

    new_permission = @drive.permissions.insert.request_schema.new({
    'role' => 'reader',
    'type' => 'anyone',
    })
    result = Array.new
    page_token = nil
    begin
      parameters = {}
      if page_token.to_s != ''
        parameters['pageToken'] = page_token
      end
      api_result = @api.execute(
        :api_method => @drive.files.list,
        :parameters => parameters)
      if api_result.status == 200
        files = api_result.data
        result.concat(files.items)
        page_token = files.next_page_token

        result.each do |file|
          @api.execute(
          :api_method => @drive.permissions.insert,
          :body_object => new_permission,
          :parameters => { 'fileId' => file.id })
        end
      else
        puts "An error occurred: #{result.data['error']['message']}"
        page_token = nil
      end
    end while page_token.to_s != ''
    result
  end

    private

    def api_service
      key = Google::APIClient::KeyUtils.load_from_pkcs12('a3ac5bd54d15c78a70383c26d1e4f0c54a2bb728-privatekey.p12', 'notasecret')
      client = Google::APIClient.new
      client.authorization = Signet::OAuth2::Client.new(
      	:token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      	:audience => 'https://accounts.google.com/o/oauth2/token',
      	:scope => 'https://www.googleapis.com/auth/drive',
      	:issuer => '205788113661-sgp648hint92qnrofku2ebl45q10ldkf@developer.gserviceaccount.com',
      	:signing_key => key)

      client.authorization.fetch_access_token!

      return client
    end
  end
end
