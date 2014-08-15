# Log
echo "Vagrant base box built with veewee($(cat .veewee_version)), on $(date)." >> /var/log/vagrant_box_build.log
#dpkg --get-selections > /var/log/vagrant_box_build.dpkg_selections.0.txt
#apt-mark showmanual | sort > /var/log/vagrant_box_build.apt_mark.0.txt
#df -h > /var/log/vagrant_box_build.disk_free.0.txt

# Set up sudo
echo 'vagrant ALL=NOPASSWD:ALL' > /etc/sudoers.d/vagrant

# Tweak sshd to prevent DNS resolution (speed up logins)
echo 'UseDNS no' >> /etc/ssh/sshd_config

# Remove 5s grub timeout to speed up booting
sed -i 's/^\(GRUB_TIMEOUT\)=.*/\1=0/' /etc/default/grub
update-grub

# Install packages
# remove and exclude doc files
cat <<EOF > /etc/dpkg/dpkg.cfg.d/90_nodoc
path-exclude /usr/share/doc/*
path-exclude /usr/share/info/*
EOF
rm -rf /usr/share/doc/* /usr/share/info/*

# set up apt
mv /etc/apt/sources.list /etc/apt/sources.list~
cat > /etc/apt/sources.list.d/official.cdn.list <<EOF
deb http://cdn.debian.net/debian/ wheezy main contrib non-free
deb http://cdn.debian.net/debian/ jessie main contrib non-free
deb http://cdn.debian.net/debian/ sid main contrib non-free
#deb http://security.debian.org/ testing/updates main contrib non-free
deb http://security.debian.org/ wheezy/updates main contrib non-free
deb http://security.debian.org/ jessie/updates main contrib non-free
EOF
DEFAULT_DEBIAN_RELEASE=wheezy
echo "APT::Default-Release \"${DEFAULT_DEBIAN_RELEASE}\";" > "/etc/apt/apt.conf.d/24${DEFAULT_DEBIAN_RELEASE}"
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/25norecommends
aptitude -q2 update
aptitude -q2 -y full-upgrade

# basic utils
# already installed with netinst: openssh-server
aptitude -q2 -y install bzip2 curl htop less lsof nfs-common rsync ruby unzip bash-completion
aptitude -q2 -y -t jessie install git rbenv ruby-build supervisor

# needed to compile ruby and python
# ref: https://github.com/sstephenson/ruby-build/wiki
# ref: https://github.com/yyuu/pyenv/wiki/Common-build-problems
aptitude -q2 -y -t jessie install autoconf automake+M bison build-essential libbz2-dev libreadline6 libreadline6-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g zlib1g-dev libsqlite3-dev+M libxml2-dev+M libxslt1-dev+M

## supervisor

# user settings
echo -e "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\"\nexport PATH" > /etc/profile.d/set_path.sh
