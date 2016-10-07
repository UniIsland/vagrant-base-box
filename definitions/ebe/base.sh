# Log
echo "$(date)" >> /var/log/vagrant_box_build.log
echo "Vagrant base box built with veewee v$(cat .veewee_version) and virtualbox v$(cat .vbox_version)." >> /var/log/vagrant_box_build.log
echo "- build parameters: ($(cat .veewee_params))." >> /var/log/vagrant_box_build.log
#dpkg --get-selections > /var/log/vagrant_box_build/dpkg_selections.0.txt
#apt-mark showmanual | sort > /var/log/vagrant_box_build/apt_mark.0.txt
#df -h > /var/log/vagrant_box_build/disk_free.0.txt
#ps aux >  /var/log/vagrant_box_build/ps_aux.0.txt
#env >  /var/log/vagrant_box_build/env.0.txt

# Remove 5s grub timeout to speed up booting
sed -i 's/^\(GRUB_TIMEOUT\)=.*/\1=0/' /etc/default/grub
update-grub

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config
# fix perl locale issue
sed -i "s/^AcceptEnv /#AcceptEnv /" /etc/ssh/sshd_config
/etc/init.d/ssh restart

# Install packages
# remove and exclude doc files
cat <<EOF > /etc/dpkg/dpkg.cfg.d/90_nodoc
path-exclude /usr/share/doc/*
path-exclude /usr/share/info/*
EOF
rm -rf /usr/share/doc/* /usr/share/info/*

# set up apt
DEBIAN_MIRROR="http://httpredir.debian.org/debian"
DEBIAN_RELEASE_STABLE=jessie
DEBIAN_RELEASE_TESTING=stretch
mv /etc/apt/sources.list /etc/apt/sources.list~
cat > /etc/apt/sources.list.d/official.cdn.list <<EOF
deb ${DEBIAN_MIRROR} ${DEBIAN_RELEASE_STABLE} main contrib non-free
deb ${DEBIAN_MIRROR} ${DEBIAN_RELEASE_TESTING} main contrib non-free
deb ${DEBIAN_MIRROR} sid main contrib non-free
#deb http://security.debian.org/ testing/updates main contrib non-free
deb http://security.debian.org/ ${DEBIAN_RELEASE_STABLE}/updates main contrib non-free
deb http://security.debian.org/ ${DEBIAN_RELEASE_TESTING}/updates main contrib non-free
EOF
echo "APT::Default-Release \"${DEBIAN_RELEASE_TESTING}\";" > "/etc/apt/apt.conf.d/24${DEBIAN_RELEASE_TESTING}"
#echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/25norecommends

# update packages
apt-get -q update
apt-get install -q2 -y aptitude
aptitude -q2 update
aptitude -q2 -y full-upgrade

# basic utils
# already installed with netinst: openssh-server
aptitude -q2 -y install bzip2 ca-certificates curl file git htop less lsb-release lsof nfs-common patch python rsync ruby unzip vim-nox zsh
# needed to compile ruby and python
# ref: https://github.com/sstephenson/ruby-build/wiki
# ref: https://github.com/yyuu/pyenv/wiki/Common-build-problems
aptitude -q2 -y install autoconf automake+M bison build-essential libbz2-dev libreadline6 libreadline6-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g zlib1g-dev libsqlite3-dev+M libxml2-dev+M libxslt1-dev+M libmysqlclient-dev
aptitude -q2 -y install rbenv ruby-build libsqlite3-dev+M libxml2-dev+M libxslt1-dev+M

# user settings
echo "export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"" > /etc/profile.d/00set_path.sh
# use zsh as login shell
chsh -s `which zsh` vagrant
mv /etc/zsh/zshenv /etc/zsh/zshenv.orig
cat > /etc/zsh/zshenv <<"EOF"
PATH_OLD="$PATH"
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin
EOF
cp /etc/zsh/newuser.zshrc.recommended /home/vagrant/.zshrc
cat >> /home/vagrant/.zshrc <<"EOF"

# init rbenv
eval "$(rbenv init - zsh)"
EOF
chown vagrant:vagrant /home/vagrant/.zshrc

# # install chef
# echo "chef    chef/chef_server_url    string  $CHEF_SERVER_URL" | debconf-set-selections
# aptitude -q2 -y install chef
