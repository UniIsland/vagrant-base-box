Custom definitions for building debian vagrant base boxes.
Inspired by [[https://github.com/dotzero/vagrant-debian-wheezy-64]]

# Usage

## install requirements
### install virtualbox
aptitude install virtualbox virtualbox-dkms virtualbox-guest-additions-iso
### install vagrant
> https://www.vagrantup.com/downloads.html
wget -P ./tmp https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
dpkg -i ./tmp/vagrant_1.6.3_x86_64.deb
### bundle
bundle install

## [optional] get example definition
veewee-templates-update
veewee vbox templates
veewee vbox define `box_name` `template`

## fetch debian weekly build iso
> wget -P ./iso http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-7.6.0-amd64-netinst.iso
curl -Lo ./iso/debian-testing-amd64-netinst_$(date +%Y%m%d).iso http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
ln -sf debian-testing-amd64-netinst_$(date +%Y%m%d).iso ./iso/debian-testing-amd64-netinst.iso

## link vbox iso
### on Mac OSX
ln -sf /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso ./iso/VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso
### on Linux
ln -sf /usr/share/virtualbox/VBoxGuestAdditions.iso ./iso/VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso
### symlink
ln -sf ./VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso ./iso/VBoxGuestAdditions.iso

## choose a box name from
https://en.wikipedia.org/wiki/List_of_Star_Wars_characters

## custom box definition
vi definitions/debian-weekly_140818-amd64-anakin/*
ln -s debian-weekly_140818-amd64-anakin definitions/anakin

## build
veewee vbox build debian-7.3.0-i386-caedus --force --nogui 2> ./tmp/build.err | tee ./tmp/build.out

## ssh into the box and do whatever you want
veewee vbox ssh debian-7.3.0-i386-caedus

## export the vm to a .box file
veewee vbox export debian-7.3.0-i386-caedus

## import the box with vagrant
vagrant box add 'debian-7.6.0-amd64-dooku' './debian-7.6.0-amd64-dooku.box'

## use the newly built box in your project
vagrant init 'debian-7.6.0-amd64-dooku'
vagrant up
vagrant ssh


# Other Tasks

## Preseeding Debian Installer
### references:
https://wiki.debian.org/DebianInstaller/Preseed
https://www.debian.org/releases/stable/amd64/apb.html.en
### generating example preseed on an existing system
aptitude install debconf-utils
debconf-get-selections --installer > preseed.cfg
debconf-get-selections >> preseed.cfg
### get debconf answers of a specific package
debconf-get-selections | grep `package_name`
### check if preseed file is valid
debconf-set-selections -c preseed.cfg
### where to look for debconf template
/var/log/installer/
/var/lib/cdebconf while an installation is in progress

## Answer Questions Failed to Automate with Preseed.cfg
### take screenshot
veewee vbox screenshot anakin tmp/anakin.png
### send key sequence to the vm
veewee vbox sendkeys anakin '/dev/sda'
veewee vbox sendkeys anakin '<Enter>'
