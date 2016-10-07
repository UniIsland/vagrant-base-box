# Install VirtualBox guest additions

if test -f .vbox_version ; then
  # install dependencies
  # If libdbus is not installed, virtualbox will not autostart
  aptitude -q2 -y -R install dkms libdbus-1-3 linux-headers-amd64 #linux-headers-$(uname -r)

  # Install the VirtualBox guest additions
  VBOX_VERSION=$(cat .vbox_version)
  VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
  modprobe loop
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run --nox11
  umount /mnt

  # Start the newly build driver
  /etc/init.d/vboxadd start

  # Make a temporary mount point
  mkdir /tmp/veewee-validation

  # Test mount the veewee-validation
  mount -t vboxsf veewee-validation /tmp/veewee-validation

  # clean up
  #aptitude -q2 -y remove linux-headers-$(uname -r)
  #aptitude -q2 -y purge '~i linux-headers'

  echo "VirtualBox Guest Additions ($(cat .vbox_version)) installed." >> /var/log/vagrant_box_build.log

fi
