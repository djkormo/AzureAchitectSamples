#!/bin/bash
 
apt-get -y update
 
logger "Installing Apache WebSite"
 
# Set up a silent install of MySQL
dbpass=$1
 
export DEBIAN_FRONTEND=noninteractive
echo mysql-server-5.6 mysql-server/root_password password $dbpass | debconf-set-selections
echo mysql-server-5.6 mysql-server/root_password_again password $dbpass | debconf-set-selections
 
# Install the LAMP stack 
apt-get -y install apache2 mysql-server php php-mysql libapache2-mod-php php-mcrypt 
# Install additional packages
apt-get -y install mc lynx 
# put main page on WebSite
echo "Done"

git clone https://github.com/djkormo/simple-chess-ai
 
# copy content to apache root directory
cd simple-chess-ai && cp -R .  /var/www/html/ && cd .. && rm -r  simple-chess-ai/
chmod a+x -R /var/www/html/

cd 
# installing framework for consistent backup

# https://docs.microsoft.com/en-us/azure/backup/backup-azure-linux-app-consistent

if [ ! -d "/etc/azure" ]; then
  # Control will enter here if /etc/azure doesn't exist.
  mkdir /etc/azure
fi


wget https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/13Monitoring/VMSnapshotScriptPluginConfig.json 
cp VMSnapshotScriptPluginConfig.json /etc/azure
chmod 600 /etc/azure/VMSnapshotScriptPluginConfig.json

wget https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/13Monitoring/post-script.sh
cp post-script.sh /etc/azure
chmod 700 /etc/azure/post-script.sh

wget https://raw.githubusercontent.com/djkormo/AzureAchitectSamples/master/13Monitoring/pre-script.sh
cp pre-script.sh /etc/azure
chmod 700 /etc/azure/pre-script.sh

