#!/usr/bin/env bash

echo "
----------------------
  CONFIGURING FIREWALL
----------------------
"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 'Nginx HTTP'
echo "
----------------------
  OPENING PORT FOR GOLAN CHESS ENGINE (GLEE)
----------------------
"
sudo ufw allow 8443/tcp
sudo ufw enable
