# Reduce Size
# https://wiki.debian.org/ReduceDebian

# locale purge
cat <<EOF | debconf-set-selections
localepurge localepurge/nopurge multiselect en, en_US.UTF-8
localepurge localepurge/use-dpkg-feature  boolean false
localepurge localepurge/verbose boolean false
EOF
aptitude -q2 -y -R install localepurge
localepurge
# remove unnecessary packages
aptitude -q2 -y purge discover info install-info installation-report
# Clean up apt
aptitude -q2 clean
#apt-get -y autoremove

# Removing leftover leases and persistent rules
rm -v /var/lib/dhcp/*

# Make sure Udev doesn't block our network
# rm -v /etc/udev/rules.d/70-persistent-net.rules
# mkdir /etc/udev/rules.d/70-persistent-net.rules
# rm -rfv /dev/.udev/
# rm -v /lib/udev/rules.d/75-persistent-net-generator.rules

# Adding a 2 sec delay to the interface up, to make the dhclient happy
echo "pre-up sleep 2" >> /etc/network/interfaces

# Clean up veewee files
# rm -v "VBoxGuestAdditions_$(cat .vbox_version).iso"
rm -v /var/cache/debconf/*
