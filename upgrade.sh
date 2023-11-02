#!/bin/bash

# Check if running with root privileges
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Choose PVE version
echo -n "What is your PVE version(3/4/5/6/7/8):"
read pve_version

case $pve_version in
3)
    debian_version="wheezy"
    ;;
4)
    debian_version="jessie"
    ;;
5)
    debian_version="stretch"
    ;;
6)
    debian_version="buster"
    ;;
7)
    debian_version="bullseye"
    ;;
8)
    debian_version="bookworm"
    ;;
*)
    echo "You have not chosen a valid PVE version."
    exit 1
    ;;
esac
echo "You have chosen PVE ${pve_version}.*, based on Debian ${debian_version}"

# Delete enterprise repo
rm -f /etc/apt/sources.list.d/pve-enterprise.list

# Add 7.x repo into update list
echo "deb http://download.proxmox.com/debian/pve ${debian_version} pve-no-subscription" >>/etc/apt/sources.list.d/pve-install-repo.list

# Get release key
wget -q http://download.proxmox.com/debian/proxmox-release-${debian_version}.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-${debian_version}.gpg

# Update & Upgrade
apt update && apt dist-upgrade -y

# Check if apt commands were successful
if [ $? -eq 0 ]; then
    echo "Update and upgrade completed successfully."
else
    echo "Update or upgrade encountered an error."
fi
