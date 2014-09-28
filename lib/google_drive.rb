require 'rubygems'
require 'google/api_client'
require 'launchy'

module Service
  class GoogleDrive

    PDF_THUMBNAIL = 'http://farm4.staticflickr.com/3852/15187675380_7b00f5fdff_b.jpg'

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

        file = @api.execute(
          :api_method => @drive.files.get,
          :parameters => { 'fileId' => result.data.id })

        new_permission = @drive.permissions.insert.request_schema.new({
          'role' => 'reader',
          'type' => 'anyone',
        })

        @api.execute(
          :api_method => @drive.permissions.insert,
          :body_object => new_permission,
          :parameters => { 'fileId' => result.data.id })

        {link:result.data.webContentLink, thumbnail: PDF_THUMBNAIL, title: result.data.title}
      end
    end

    private

    def api_service
      key = OpenSSL::PKey::RSA.new Base64.decode64(ENV['GOOGLE_API_KEY']), 'notasecret'

      client = Google::APIClient.new
      client.authorization = Signet::OAuth2::Client.new(
        token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
        audience: 'https://accounts.google.com/o/oauth2/token',
        scope: 'https://www.googleapis.com/auth/drive',
        issuer: ENV['GOOGLE_EMAIL_ADDRESS'],
        signing_key: key)

      client.authorization.fetch_access_token!

      return client
    end
  end
end
