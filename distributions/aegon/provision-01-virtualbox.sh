#!/bin/bash

## must run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# install dependencies
# If libdbus is not installed, virtualbox will not autostart
aptitude -q2 -y -R install dkms libdbus-1-3 linux-headers-amd64 #linux-headers-$(uname -r)

# Install the VirtualBox guest additions
# copy iso from /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso
VBOX_ISO=VBoxGuestAdditions.iso
modprobe loop
mount -o loop $VBOX_ISO /mnt
yes|sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

# clean up
#aptitude -q2 -y remove linux-headers-$(uname -r)
#aptitude -q2 -y purge '~i linux-headers'
