#! /bin/bash

log=~/install.log
nginxPath=/usr/share/nginx/html/

sudo apt-get update >> $log 2>&1
sudo apt-get install -y apache2 >> $log 2>&1
sudo systemctl start apache2 >> $log 2>&1
sudo systemctl enable apache2 >> $log 2>&1
echo "The page was created by the user data instance 0" | sudo tee /var/www/html/index.html >> $log 2>&1

sudo cp ~/install.log "${nginxPath}/install.log"