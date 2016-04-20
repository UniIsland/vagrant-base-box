#!/bin/bash

## must run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

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

rm -v /var/cache/debconf/*

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
