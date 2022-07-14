#!/usr/bin/env bash

echo "
----------------------
  NGINX
----------------------
"

# let Nginx through firewall
sudo ufw allow 'Nginx Full'


sudo mkdir -p /var/www/tonycodes.com/html
sudo chown -R $USER:$USER /var/www/tonycodes.com/html
sudo chmod -R 755 /var/www/tonycodes.com
