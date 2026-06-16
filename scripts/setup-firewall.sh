#!/bin/bash

echo "Setting up UFW through ansible to allow SSH and web traffic..."
sleep 3

sudo ansible-playbook ../playbooks/web-firewall.yaml