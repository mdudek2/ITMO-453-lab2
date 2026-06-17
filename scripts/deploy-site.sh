#!/bin/bash

# deploy site using ansible
echo "Deploying hello test site to each webserver via ansible..."

sudo ansible-playbook ../playbooks/deploy-website.yaml

