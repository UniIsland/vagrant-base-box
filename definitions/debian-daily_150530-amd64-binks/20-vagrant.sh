# Set up Vagrant.

# Install vagrant keys
mkdir -pm 700 /home/vagrant/.ssh
curl -Lkso /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Vagrant insecure ssh public key installed." >> /var/log/vagrant_box_build.log
