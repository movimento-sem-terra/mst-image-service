require 'google/api_client'
require 'mime-types'

module Service
  class GoogleDrive

    PDF_THUMBNAIL = 'http://farm4.staticflickr.com/3852/15187675380_7b00f5fdff_b.jpg'
    AUDIO_THUMBNAIL = 'http://farm4.staticflickr.com/3939/15458051067_f2f7afa6e8_b.jpg'

    def initialize(api=nil, drive=nil)
      @api = api || api_service
      @drive = drive || @api.discovered_api('drive', 'v2')
    end

    def upload(file_path, file_name)
      content_type = get_content_type(file_name)
      file = @drive.files.insert.request_schema.new({
        'title' => file_name,
        'description' => 'v1d4 l0k4',
        'mimeType' => content_type
      })

      media = Google::APIClient::UploadIO.new(file_path, content_type )
      result = @api.execute(
        :api_method => @drive.files.insert,
        :media => media,
        :body_object => file,
        :parameters => {
          'uploadType' => 'multipart' })

      new_permission = @drive.permissions.insert.request_schema.new({
        'role' => 'reader',
        'type' => 'anyone'
      })

      @api.execute(
        :api_method => @drive.permissions.insert,
        :body_object => new_permission,
        :parameters => { 'fileId' => result.data.id }
      )
      {link:result.data.webContentLink, thumbnail: get_thumbnail(file_name), title: result.data.title}
    end

    private
    def get_thumbnail file_name
      is_audio = MIME::Types.of(file_name).first.media_type == 'audio'

      if is_audio
        AUDIO_THUMBNAIL
      else
        PDF_THUMBNAIL
      end
    end

    def get_content_type file_name
      MIME::Types.of(file_name).first.content_type
    end

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
