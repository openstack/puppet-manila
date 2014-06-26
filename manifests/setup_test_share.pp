# == Class: manila::setup_test_share
#
# Setup a share group on a loop device for test purposes.
#
# === Parameters
#
# [*share_name*]
#   Share group name. Defaults to 'manila-shares'.
#
# [*size*]
#   Share group size. Defaults to '4G'.
#
# [*loopback_device*]
#   Loop device name. Defaults to '/dev/loop2'.
#
class manila::setup_test_share(
  $share_name     = 'manila-shares',
  $size            = '4G',
  $loopback_device = '/dev/loop2'
) {

  Exec {
    cwd => '/tmp/',
  }

  package { 'lvm2':
    ensure => present,
  } ~>

  exec { "/bin/dd if=/dev/zero of=${share_name} bs=1 count=0 seek=${size}":
    unless => "/sbin/vgdisplay ${share_name}"
  } ~>

  exec { "/sbin/losetup ${loopback_device} ${share_name}":
    refreshonly => true,
  } ~>

  exec { "/sbin/pvcreate ${loopback_device}":
    refreshonly => true,
  } ~>

  exec { "/sbin/vgcreate ${share_name} ${loopback_device}":
    refreshonly => true,
  }

}

