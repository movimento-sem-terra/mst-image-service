require 'rubygems'
require 'google/api_client'
require 'launchy'

module Service
  class GoogleDrive

    def initialize(api=nil, drive=nil)
      @api = api || api_service
      @drive = drive || @api.discovered_api('drive', 'v2')
    end

    def list
      result = @api.execute(
          :api_method => @drive.files.list,
          :parameters => {})
      return result.data.items
    end

    def upload(file_path, file_name)
      begin
        file = @drive.files.insert.request_schema.new({
          'title' => file_name,
          'description' => 'post pdf file',
          'mimeType' => 'application/pdf'
          })

        media = Google::APIClient::UploadIO.new(file_path, 'application/pdf')
        result = @api.execute(
          :api_method => @drive.files.insert,
          :body_object => file,
          :media => media,
          :parameters => {
            'uploadType' => 'multipart',
            'alt' => 'json'})

        new_permission = @drive.permissions.insert.request_schema.new({
          'role' => 'reader',
          'type' => 'anyone',
        })

        @api.execute(
          :api_method => @drive.permissions.insert,
          :body_object => new_permission,
          :parameters => { 'fileId' => result.data.id })

        result.data.webContentLink
      end
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
