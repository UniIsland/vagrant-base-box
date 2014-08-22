# Prepare puppetlabs repo
wget -nv http://apt.puppetlabs.com/puppetlabs-release-wheezy.deb
dpkg -i puppetlabs-release-wheezy.deb
rm -v puppetlabs-release-wheezy.deb
aptitude -q2 -y update

# Install puppet/facter
aptitude -q2 -y -R install puppet facter

echo "Puppet($(puppet --version)) installed." >> /var/log/vagrant_box_build.log
