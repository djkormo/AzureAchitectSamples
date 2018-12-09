#!/bin/bash
logger "Installing WordPress"
apt-get -y update

apt-get install -y apache2  php php-mysql libapache2-mod-php php-mcrypt mc lynx stress

git clone https://github.com/djkormo/wordpressfiles.git
cd wordpressfiles/

sudo cp -R * /var/www/html/

service apache2 restart



logger "Done installing WordPress; open /html/index.php to configure"






