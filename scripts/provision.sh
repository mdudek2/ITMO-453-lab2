#!/bin/bash

# variables for vm config

vm_name="itmo-453-lab2-ubuntu-webserver-01"
vm_ram=4096
vm_cpus=2
vm_disk_size=25000
vm_dir="$HOME/itmo-453-vms"

echo "Starting vm provisioning..."
sleep 3

# Create the virtual machine
echo "Creating vm: "$vm_name""
sleep 3
VBoxManage createvm --name "$vm_name" \
  --ostype Ubuntu_64 \
  --register

# Configure CPU and RAM 
echo "Setting up the CPU and RAM..."
sleep 3
VBoxManage modifyvm "$vm_name" \
  --memory "$vm_ram" \
  --cpus "$vm_cpus" \
  --nic1 nat \
  --nic2 hostonly --hostonlyadapter2 vboxnet0

# Create a Disk
echo "Creating a virtual hard disk..."
sleep 3
VBoxManage createmedium disk --filename "$vm_dir/$vm_name.vdi" \
  --size "$vm_disk_size"

# Add a Sata Controller
echo "Setting up the Sata Controller..."
sleep 3
VBoxManage storagectl "$vm_name" --name SATA --add sata --controller IntelAhci

# Attach a Disk
echo "Attaching the disk to the VM..."
sleep 3
VBoxManage storageattach "$vm_name" \
  --storagectl SATA \
  --port 0 \
  --device 0 \
  --type hdd \
  --medium "$vm_dir/$vm_name.vdi"

# Add and attach IDE Controller
echo "Setting up the IDE Controller..."
sleep 3
VBoxManage storagectl "$vm_name" --name IDE --add ide
VBoxManage storageattach "$vm_name" --storagectl IDE \
 --port 0 \
 --device 0 \
 --type dvddrive \
 --medium "$HOME/isos/ubuntu-24.04.4-live-server-amd64.iso"

# Install the OS via unattended install
VBoxManage unattended install "$vm_name" \
  --iso="$HOME/isos/ubuntu-24.04.4-live-server-amd64.iso" \
  --user=ubuntu \
  --full-user-name=ubuntu \
  --password ubuntu \
  --time-zone=America/Chicago \
  --post-install-template="postinstall.sh"

# Start the VM
VBoxManage startvm "$vm_name" --type headless
