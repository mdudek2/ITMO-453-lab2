#!/bin/bash

# variables for vm config

vm_name="lab2-ubuntu-webserver-template"
vm_ram=4096
vm_cpus=2
vm_disk_size=25000
vm_dir="$HOME/itmo-453-vms"

echo "Starting template creation.."
sleep 3

# Create the virtual machine
echo "Creating vm: "$vm_name""
sleep 3
VBoxManage createvm --name "$vm_name" \
  --ostype Ubuntu_64 \
  --register

# Configure CPU, RAM, and Graphics 
echo "Setting up hardware..."
sleep 3
VBoxManage modifyvm "$vm_name" \
  --memory "$vm_ram" \
  --cpus "$vm_cpus" \
  --nic1 nat \
  --nic2 hostonly --hostonlyadapter2 vboxnet0 \
  --vram 16 \
  --graphicscontroller vmsvga

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

# start the vm
VBoxManage startvm "$vm_name" --type headless

# Wait for the VM to finish installing
echo "Waiting for the VM to finish installing..."
sleep 360

# Acquire networking data for SSH
echo "Acquiring network information..."

mac_addr=$(VBoxManage showvminfo "$vm_name" --machinereadable \
  | awk -F'"' '/macaddress2/ {print $2}')

ip=$(VBoxManage dhcpserver findlease --interface=vboxnet0 --mac-address "$mac_addr" | awk -F': *' '/IP Address/ {print $2}')
echo "template IP: $ip"

# generate a key to be used for ssh
if [ ! -f ~/.ssh/lab2-ssh-key ]; then
  ssh-keygen -t ed25519 \
    -f ~/.ssh/lab2-ssh-key \
    -N "" \
    -C "automatically generated as part of lab2 deployment" \
    -q
fi

# copy the public key to the vm template
ssh-copy-id -o StrictHostKeyChecking=accept-new -i ~/.ssh/lab2-ssh-key.pub ubuntu@$ip

# Shutdowm the template so that it can be cloned safely
VBoxManage controlvm "$vm_name" acpipowerbutton
sleep 30
echo "Template has been created successfully!