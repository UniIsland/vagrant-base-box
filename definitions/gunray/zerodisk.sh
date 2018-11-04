# Log
VAGRANT_LOG_DIR=/var/log/vagrant_box_build
mv ./.vbox_version $VAGRANT_LOG_DIR/vbox_version
mv ./.veewee_params $VAGRANT_LOG_DIR/veewee_params
mv ./.veewee_version $VAGRANT_LOG_DIR/veewee_version
dpkg --get-selections | gzip > $VAGRANT_LOG_DIR/dpkg_selections.1.gz
apt-mark showmanual | sort | gzip > $VAGRANT_LOG_DIR/apt_mark.1.gz
df -h > $VAGRANT_LOG_DIR/disk_free.1.dump

# rm veewee scripts
rm -v ./*.sh

# Zero out the free space to save space in the final image:
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
