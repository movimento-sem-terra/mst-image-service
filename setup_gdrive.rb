require 'flickraw'
def green_line(text)
 puts "\\e[32m #{text}"
 print "\\e[0m"
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

red_line '#### Incompleto ####'

green_line %{
                                     ,,                    
   .g8"""bgd `7MM"""Yb.              db                    
 .dP'     `M   MM    `Yb.                                  
 dM'       `   MM     `Mb `7Mb,od8 `7MM `7M'   `MF'.gP"Ya  
 MM            MM      MM   MM' "'   MM   VA   ,V ,M'   Yb 
 MM.    `7MMF' MM     ,MP   MM       MM    VA ,V  8M"""""" 
 `Mb.     MM   MM    ,dP'   MM       MM     VVV   YM.    , 
   `"bmmmdPY .JMMmmmdP'   .JMML.   .JMML.    W     `Mbmmd' 

}

green_line '1) Acesse o endereço https://console.developers.google.com/project'
green_line '2) Crie um projeto'
green_line '3) No menu, clique em overview, depois em Enable an Api'
green_line '4) Desabilite todas as api que estão por Default'
green_line '5) Ative a Drive API'
green_line '6) Vá em API & auth > Credentials'
green_line '7) Clique em Create new Client ID'
green_line '8) Preencha os dados da tela seguinte "Consent screen" e continue'
green_line '9) Após a criação, clique em Generate new P12 key, salve em alguma pasta no seu computador'
key_path = get_response '10) Digite o caminho que a key está:'
client_id = get_response '11) Nessa mesma tela, copie e cole abaixo o Client ID'
email_address = get_response '12) ... e o EMAIL ADDRESS'
red_line 'Não implementado '