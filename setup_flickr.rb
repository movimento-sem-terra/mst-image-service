require 'flickraw'
def green_line(text)
 puts "\e[32m #{text}"
 print "\e[0m"
end


def red_line(text)
 puts "\e[31m #{text}"
 print "\e[0m"
end

def get_response(text)
  green_line text
  print ' #: '
  gets.strip
end


green_line %{
    ffffffffffffffff  lllllll   iiii                      kkkkkkkk
   f::::::::::::::::f l:::::l  i::::i                     k::::::k
  f::::::::::::::::::fl:::::l   iiii                      k::::::k
  f::::::fffffff:::::fl:::::l                             k::::::k
  f:::::f       ffffff l::::l iiiiiii     cccccccccccccccc k:::::k    kkkkkkkrrrrr   rrrrrrrrr
  f:::::f              l::::l i:::::i   cc:::::::::::::::c k:::::k   k:::::k r::::rrr:::::::::r
 f:::::::ffffff        l::::l  i::::i  c:::::::::::::::::c k:::::k  k:::::k  r:::::::::::::::::r
 f::::::::::::f        l::::l  i::::i c:::::::cccccc:::::c k:::::k k:::::k   rr::::::rrrrr::::::r
 f::::::::::::f        l::::l  i::::i c::::::c     ccccccc k::::::k:::::k     r:::::r     r:::::r
 f:::::::ffffff        l::::l  i::::i c:::::c              k:::::::::::k      r:::::r     rrrrrrr
  f:::::f              l::::l  i::::i c:::::c              k:::::::::::k      r:::::r
  f:::::f              l::::l  i::::i c::::::c     ccccccc k::::::k:::::k     r:::::r
 f:::::::f            l::::::li::::::ic:::::::cccccc:::::ck::::::k k:::::k    r:::::r
 f:::::::f            l::::::li::::::i c:::::::::::::::::ck::::::k  k:::::k   r:::::r
 f:::::::f            l::::::li::::::i  cc:::::::::::::::ck::::::k   k:::::k  r:::::r
 fffffffff            lllllllliiiiiiii    cccccccccccccccckkkkkkkk    kkkkkkk rrrrrrr

}
green_line '1) Crie um app em https://www.flickr.com/services/'

begin
  FlickRaw.api_key = get_response '2) Insira a Key do app'
  FlickRaw.shared_secret = get_response '3) Insira o Secret do app'

  token = flickr.get_request_token
  auth_url = flickr.get_authorize_url(token['oauth_token'], :perms => 'write')

  green_line "4) Abra o endereço (#{auth_url}) e autorize a aplicação"
  verify_code = get_response '5) Digite o código exibido em (https://api.flickr.com/services/oauth/authorize.gne) após a autorização'

  response = flickr.get_access_token(token['oauth_token'], token['oauth_token_secret'], verify_code)
  result  = { flickr: {api_key: FlickRaw.api_key ,shared_secret: FlickRaw.shared_secret ,token: response["oauth_token"] ,token_secret: response["oauth_token_secret"], verify_code: verify_code} }
  puts result.to_json

rescue FlickRaw::FailedResponse => e
  red_line 'Dados Inválidos'
  red_line e.message
end


