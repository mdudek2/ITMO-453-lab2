#!/bin/bash

# install openssh server and prometheus

apt install openssh-server prometheus -y

# enable ssh
systemctl enable ssh
systemctl start ssh

# enable prometheus
systemctl enable prometheus
systemctl start prometheus

# allow password authentication temporarily so that the ssh key can be copied over
# this will be disabled by an ansible play after all virtual machines start successfully
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh

reboot now