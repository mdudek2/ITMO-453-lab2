#!/bin/bash

# deploy site using ansible
echo "Deploying hello test site to each webserver via ansible..."

sleep 3
sudo ansible-playbook ../playbooks/deploy-website.yaml

