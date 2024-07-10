#!/bin/bash
# CLEAR TERMINAL
clear

# GET CURRENT SCRIPT LOCATION
SCRIPT_LOCATION=$(dirname "$(realpath "$0")")

# UPDATE SYSTEM
sudo apt update -y
sudo apt upgrade -y

# INSTALL PACKAGES
sudo apt install neofetch htop sqlite3 nodejs php php-fpm python3 python3-pip vim git make nginx mariadb-server cmake -y

# INSTALL MYSQL
sudo mysql_secure_installation

# GENERATE SSH KEY
sudo ssh-keygen -b 2048 -t rsa

# COPY SSH AUTH KEYS
mkdir /home/"${USER}"/.ssh
sudo cp "$SCRIPT_LOCATION"/config/authorized_keys /home/"${USER}"/.ssh
sudo chmod 644 /home/"${USER}"/.ssh/authorized_keys
sudo chown "${USER}":"${USER}" /home/"${USER}"/.ssh/authorized_keys

# EDIT SSH CONFIG
# backup original config
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
# remove coments and set on not
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
#  if PasswordAuthentication not exist, add on end
sudo grep -q '^PasswordAuthentication ' /etc/ssh/sshd_config || echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

# MAKE FOLDERS AND FILES
mkdir /home/"${USER}"/web
mkdir /home/"${USER}"/web/php
mkdir /home/"${USER}"/web/node
mkdir /home/"${USER}"/web/sites
cp "$SCRIPT_LOCATION"/config/index.html /home/"${USER}"/web
touch /home/"${USER}"/web/php/index.php
mkdir /home/"${USER}"/apps

# COPY NGINX CONFIG
sudo rm /etc/nginx/sites-available/default
sudo mv "$SCRIPT_LOCATION"/config/default /etc/nginx/sites-available

# DELETE APACHE
sudo systemctl stop apache2
sudo systemctl disable apache2
sudo apt purge apache2 -y

# ALLOW NGINX
sudo chown -R www-data:www-data /etc/nginx /var/www/html
sudo chmod -R 755 /etc/nginx /var/www/html
sudo systemctl start nginx.service
sudo systemctl enable nginx.service

# REBOOT
sudo reboot now