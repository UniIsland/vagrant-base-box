Veewee::Definition.declare({
  :cpu_count => '1',
  :memory_size=> '512',
  :disk_size => '10240', :disk_format => 'VDI', :hostiocache => 'off',
  :os_type_id => 'Debian_64',
  :virtualbox => {
    #:iso_src => "./iso/VBoxGuestAdditions_<version>.iso",
    :vm_options => [
      'rtcuseutc' => 'on',
      'usb' => 'off',
      'vrde' => 'off',
    ]
  },
  # http://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
  :iso_file => "debian-testing-amd64-netinst.iso",
  :iso_src => "./iso/debian-testing-amd64-netinst.iso",
  #:iso_md5 => "8a3c2ad7fd7a9c4c7e9bcb5cae38c135",
  :iso_download_timeout => "1000",
  :boot_wait => "10",
  # https://www.debian.org/releases/wheezy/i386/apbs02.html.en#preseed-bootparms
  # https://www.debian.org/releases/wheezy/i386/ch05s03.html.en
  :boot_cmd_sequence => [
     '<Esc>',
     'install ',
     'auto ',
     'priority=critical ',
     'fb=false ',
     'language=en ',
     'country=US ',
     'locale=en_US.UTF-8 ',
     'keymap=us ',
     'interface=auto ',
     'preseed/url=http://%IP%:%PORT%/preseed.cfg ',
     #'DEBIAN_FRONTEND=text ',
     '<Enter>'
  ],
  :kickstart_port => "7122",
  :kickstart_timeout => "500",
  :kickstart_file => "preseed.cfg",
  :ssh_login_timeout => "3600",
  :ssh_user => "vagrant",
  :ssh_password => "vagrant",
  :ssh_key => "",
  :ssh_host_port => "7222",
  :ssh_guest_port => "22",
  :sudo_cmd => "echo '%p'|sudo -S sh '%f'",
  :shutdown_cmd => "halt -p",
  :postinstall_files => [
    "postinstall.sh",
    #"base.sh",
    #"vagrant.sh",
    #"virtualbox.sh",
    #"puppet.sh",
    #"cleanup.sh",
    #"zerodisk.sh"
  ],
  :postinstall_timeout => "3600"
})
