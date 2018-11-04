Custom definitions for building vagrant base boxes.

> Inspired by [dotzero/vagrant-debian-wheezy-64](https://github.com/dotzero/vagrant-debian-wheezy-64)

# Usage

## install requirements (Debian Linux)

install virtualbox

    aptitude install virtualbox virtualbox-dkms virtualbox-guest-additions-iso

install vagrant

> Refs: https://www.vagrantup.com/downloads.html

    wget -P ./tmp https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb
    dpkg -i ./tmp/vagrant_1.6.3_x86_64.deb

## install requirements (Mac OS)

install virtualbox

install vagrant

install ruby and bundler

    rbenv install <latest ruby>
    gem install bundler

possible issues with nokogiri, ref: http://www.nokogiri.org/tutorials/installing_nokogiri.html

    brew install libxml2
    bundle config build.nokogiri --use-system-libraries --with-xml2-include=$(brew --prefix libxml2)/include/libxml2

## install veewee

    bundle install

## choose a box name from

For instance: https://en.wikipedia.org/wiki/List_of_Star_Wars_characters

[optional] fetch example definition

    veewee-templates-update
    veewee vbox templates
    veewee vbox define `box_name` `template`

download debian iso and take note of md5 checksum

from debian cdimage portal: https://cdimage.debian.org/cdimage/

with wget, stable

    wget -P ./iso http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-7.6.0-amd64-netinst.iso

with curl, testing weekly build

    curl -Lo ./iso/debian-testing-amd64-netinst_$(date +%Y%m%d).iso http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
    ln -sf debian-testing-amd64-netinst_$(date +%Y%m%d).iso ./iso/debian-testing-amd64-netinst.iso

link vbox guest addition iso

on Mac OSX

    ln -sf /Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso ./iso/VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso

on Linux

    ln -sf /usr/share/virtualbox/VBoxGuestAdditions.iso ./iso/VBoxGuestAdditions_$(VBoxManage --version | egrep -o '^[0-9.]*').iso

## customize box definition

    vi definitions/anakin/*

## build and export

build with veewee

    veewee vbox build anakin --force --nogui 2> ./tmp/build.err | tee ./tmp/build.out

ssh into the box and do whatever you want

    veewee vbox ssh anakin

validate the box

    veewee vbox validate anakin

export the vm to a .box file

    veewee vbox export anakin

import the box with vagrant

    vagrant box add 'anakin' './anakin.box'

## use the newly built box in your project

    vagrant init 'anakin'
    vagrant up


# Other Tasks

## start the box in headless mode

    veewee vbox up -n anakin

## skip creation process to run postinstall scripts

    veewee vbox build --skip-to-postinstall anakin

## Preseeding Debian Installer

> references:
> https://wiki.debian.org/DebianInstaller/Preseed
> https://www.debian.org/releases/stable/amd64/apb.html.en

generating example preseed on an existing system

    aptitude install debconf-utils
    debconf-get-selections --installer > preseed.cfg
    debconf-get-selections >> preseed.cfg

get debconf answers of a specific package

    debconf-get-selections | grep `package_name`

check if preseed file is valid

    debconf-set-selections -c preseed.cfg

where to look for debconf template

    # after installation
    /var/log/installer/
    # while an installation is in progress
    /var/lib/cdebconf

## Answer Questions Failed to Automate with Preseed.cfg with headless mode

take screenshot

    veewee vbox screenshot anakin tmp/anakin.png

send key sequence to the vm

    veewee vbox sendkeys anakin '/dev/sda'
    veewee vbox sendkeys anakin '<Enter>'
