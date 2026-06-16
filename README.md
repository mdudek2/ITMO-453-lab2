# ITMO-453-lab2

## Requirements:

1. A linux host system
2. Hardware that supports virtualization
3. Oracle Virtualbox
4. Ansible
5. sudo access on host system
6. awk

## Instructions
This repository contains all of the needed scripts, playbooks, and configuration files needed to deploy two basic webservers with identical configuration. 

1. Run the provision script
2. Run the initial-hardening script
3. Run the setup-firewall script
4. Run the deploy-site script

## Note

Deploy time may vary based on hardware. You will likely need to modify the paths inside some of the scripts and ansible plays to work on your system. 

## Warning

These scripts will overwrite the default inventory file in /etc/ansible/hosts. If you have something configured in this file you should back it up and store it somewhere else before running these scripts. Alternatively you can modify these scripts to use a different inventory file.
