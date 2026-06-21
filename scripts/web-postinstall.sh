#!/bin/bash

# This script is run by virtualbox on each webserver when running provision.sh

# install nginx and open-ssh-server
apt install nginx openssh-server -y

# enable nginx
systemctl enable ngnix
systemctl start nginx

# enable ssh
systemctl enable ssh
systemctl start ssh

# allow password authentication temporarily so that the ssh key can be copied over
# this will be disabled by an ansible play after all virtual machines start successfully
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

reboot now