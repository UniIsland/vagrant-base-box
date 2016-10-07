if test -f .vbox_version ; then
  # # The netboot installs the VirtualBox support (old) so we have to remove it
  # if test -f /etc/init.d/virtualbox-ose-guest-utils ; then
  #   /etc/init.d/virtualbox-ose-guest-utils stop
  # fi

  # rmmod vboxguest
  # aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils

  # install dependencies
  # If libdbus is not installed, virtualbox will not autostart
  aptitude -q2 -y -R install dkms libdbus-1-3 linux-headers-amd64 #linux-headers-$(uname -r)

  # Install the VirtualBox guest additions
  VBOX_VERSION=$(cat .vbox_version)
  VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
  # VBOX_ISO=VBoxGuestAdditions.iso
  modprobe loop
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run --nox11
  umount /mnt

  # Start the newly build driver
  # /etc/init.d/vboxadd start

  # Make a temporary mount point
  mkdir /tmp/veewee-validation

  # Test mount the veewee-validation
  mount -t vboxsf veewee-validation /tmp/veewee-validation

  rm $VBOX_ISO

  # Symlink vbox guest additions. Fix for https://github.com/mitchellh/vagrant/issues/3341
  ln -s /opt/VBoxGuestAdditions-$VBOX_VERSION/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions

  echo "VirtualBox Guest Additions ($(cat .vbox_version)) installed." >> /var/log/vagrant_box_build.log
fi
