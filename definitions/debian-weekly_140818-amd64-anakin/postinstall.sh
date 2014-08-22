# Log
echo "Vagrant base box built with veewee v($(cat .veewee_version)), on $(date)." >> /var/log/vagrant_box_build.log
dpkg --get-selections > /var/log/vagrant_box_build.dpkg_selections.0.txt
apt-mark showmanual | sort > /var/log/vagrant_box_build.apt_mark.0.txt
df -h > /var/log/vagrant_box_build.disk_free.0.txt
ps aux >  /var/log/vagrant_box_build.ps_aux.0.txt
env >  /var/log/vagrant_box_build.env.0.txt

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config
# fix perl locale issue
sed -i "s/^AcceptEnv /#AcceptEnv /" /etc/ssh/sshd_config
/etc/init.d/ssh restart

