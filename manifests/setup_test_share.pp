#NTAP: this needs to be tweaked - no idea what to put here
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
# [*share_path*]
#   Share image location. Defaults to '/var/lib/manila'.
class manila::setup_test_share(
  $share_name     = 'manila-shares',
  $share_path     = '/var/lib/manila',
  $size            = '4G',
  $loopback_device = '/dev/loop2'
) {

  package { 'nfs-utils':
    ensure => present,
  } ~>

  file { $share_path:
    ensure  => directory,
    owner   => 'manila',
    group   => 'manila',
    require => Package['manila'],
  } ~>

  exec { "create_${share_path}/${share_name}":
    command => "dd if=/dev/zero of=\"${share_path}/${share_name}\" bs=1 count=0 seek=${size}",
    path    => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless  => "stat ${share_path}/${share_name}",
  } ~>

  exec { "losetup ${loopback_device} ${share_path}/${share_name}":
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    refreshonly => true,
  } ~>

  exec { "pvcreate ${loopback_device}":
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless      => "pvdisplay | grep ${share_name}",
    refreshonly => true,
  } ~>

  exec { "vgcreate ${share_name} ${loopback_device}":
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    refreshonly => true,
  }

}

