#!/bin/bash

## must run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" >&2
   exit 1
fi

# fix perl locale issue
sed -i "s/^AcceptEnv /#AcceptEnv /" /etc/ssh/sshd_config
/etc/init.d/ssh restart

# remove and exclude doc files
cat <<EOF > /etc/dpkg/dpkg.cfg.d/90_nodoc
path-exclude /usr/share/doc/*
path-exclude /usr/share/info/*
EOF
rm -rf /usr/share/doc/* /usr/share/info/*

# set up apt
DEBIAN_RELEASE_STABLE=jessie
DEBIAN_RELEASE_TESTING=stretch
DEBIAN_MIRROR="http://httpredir.debian.org/debian"
mv /etc/apt/sources.list /etc/apt/sources.list~
cat > /etc/apt/sources.list.d/official.httpredir.list <<EOF
deb ${DEBIAN_MIRROR} ${DEBIAN_RELEASE_STABLE} main contrib non-free
deb ${DEBIAN_MIRROR} ${DEBIAN_RELEASE_TESTING} main contrib non-free
deb ${DEBIAN_MIRROR} sid main contrib non-free
#deb http://security.debian.org/ testing/updates main contrib non-free
deb http://security.debian.org/ ${DEBIAN_RELEASE_STABLE}/updates main contrib non-free
deb http://security.debian.org/ ${DEBIAN_RELEASE_TESTING}/updates main contrib non-free
EOF
echo "APT::Default-Release \"${DEBIAN_RELEASE_STABLE}\";" > "/etc/apt/apt.conf.d/24${DEBIAN_RELEASE_STABLE}"
echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/25norecommends

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
aptitude -q2 -y install autoconf automake+M bison build-essential libbz2-dev libreadline6 libreadline6-dev libsqlite3-dev libssl-dev libyaml-dev zlib1g zlib1g-dev libsqlite3-dev+M libxml2-dev+M libxslt1-dev+M libmysqlclient-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev
aptitude -q2 -y install rbenv ruby-build libsqlite3-dev+M libxml2-dev+M libxslt1-dev+M

## mysql
## credentials for local development env. not meant to be kept secret anyway
MYSQL_ROOT_PASSWD=vagrantmysql
echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWD" | debconf-set-selections
aptitude -yq install mysql-server mysql-client redis-server
## tune mysql


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
