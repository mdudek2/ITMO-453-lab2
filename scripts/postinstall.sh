#!/bin/bash

# install nginx and open-ssh-server
apt install nginx openssh-server -y

# enable nginx
systemctl enable ngnix
systemctl start nginx

# enable ssh
systemctl enable ssh
systemctl start ssh

# allow password authentication temporarily
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

reboot now