## Dependencies
aptitude -q2 -y -R install dkms libdbus-1-3 linux-headers-$(uname -r)

## Install the VirtualBox guest additions
VBOX_VERSION=$(cat .vbox_version)
VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
modprobe loop
mount -o loop $VBOX_ISO /mnt
yes|sh /mnt/VBoxLinuxAdditions.run --nox11
umount /mnt

rm $VBOX_ISO
