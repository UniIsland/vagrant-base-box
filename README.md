Custom definitions for building debian vagrant base boxes.
Inspired by [[https://github.com/dotzero/vagrant-debian-wheezy-64]]

# Usage

(To be updated)

## requirements
install virtualbox vagrant

## prepare
bundle install
veewee-templates-update

## get example definition
veewee vbox templates

## iso
ln -s /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso ./iso
ln -s ./VBoxGuestAdditions.iso ./iso/VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso
wget -P ./iso http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-7.6.0-amd64-netinst.iso 

## build
veewee vbox build debian-7.3.0-i386-caedus --force --nogui 2> ./tmp/build.err | tee ./tmp/build.out
veewee vbox export debian-7.3.0-i386-caedus

## vagrant
vagrant box add 'debian-7.6.0-amd64-dooku' '/Users/tao/development/sandbox/vagrant-base-box/debian-7.6.0-amd64-dooku.box'
vagrant init 'debian-7.6.0-amd64-dooku'
vagrant up
vagrant ssh