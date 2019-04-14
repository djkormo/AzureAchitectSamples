#!/bin/bash
 
# generating random number between 1 and 10 
$(( ( RANDOM % 10 )  + 1 )) 
apt-get -y update
 
logger "Installing Apache WebSite"
 

 
export DEBIAN_FRONTEND=noninteractive

# Install the LAMP stack 
apt-get -y install apache2  php libapache2-mod-php
# Install additional packages
apt-get -y install mc lynx 
# put main page on WebSite
echo "Done"

cd 

if [ ! -d "install" ]; then
  # Control will enter here if intall directory doesn't exist.
  mkdir install
fi

cd install 
# getting content of website 
#git clone https://github.com/djkormo/simple-chess-ai
 
# copy content to apache root directory
#cd simple-chess-ai && cp -R .  /var/www/html/ && cd .. && rm -r  simple-chess-ai/
#chmod a+x -R /var/www/html/


git clone https://github.com/djkormo/AzureAchitectSamples.git

cp -R AzureAchitectSamples/samples/cli/IaaS/html/ /var/www/html/

chmod a+x -R /var/www/html/ 





