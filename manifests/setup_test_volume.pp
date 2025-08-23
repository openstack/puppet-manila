# == Class: manila::setup_test_volume
#
# Setup a volume group on a loop device for test purposes.
#
# === Parameters
#
# [*volume_name*]
#   (Optional) Volume group name.
#   Defaults to 'lvm-shares'.
#
# [*size*]
#   (Optional) Volume group size.
#   Defaults to '4G'.
#
# [*loopback_device*]
#   (Optional) Loop device name.
#   Defaults to '/dev/loop2'.
#
# [*volume_path*]
#   (Optional) Volume image location.
#   Defaults to '/var/lib/manila'.
#
class manila::setup_test_volume (
  String[1] $volume_name            = 'lvm-shares',
  Stdlib::Absolutepath $volume_path = '/var/lib/manila',
  $size                             = '4G',
  $loopback_device                  = '/dev/loop2'
) {
  include manila::deps

  stdlib::ensure_packages ( 'lvm2', {
    ensure => present,
  })
  Package<| title == 'lvm2' |> { tag +> 'manila-support-package' }

  exec { "create_${volume_path}/${volume_name}":
    command   => "dd if=/dev/zero of=\"${volume_path}/${volume_name}\" bs=1 count=0 seek=${size}",
    path      => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless    => "stat ${volume_path}/${volume_name}",
    require   => Anchor['manila::install::end'],
    subscribe => Package['lvm2'],
  }
  ~> file { "${volume_path}/${volume_name}":
    mode => '0640',
  }
  ~> exec { "losetup ${loopback_device} ${volume_path}/${volume_name}":
    command     => "losetup ${loopback_device} ${volume_path}/${volume_name} && udevadm settle",
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless      => "losetup ${loopback_device}",
    refreshonly => true,
  }
  ~> exec { "pvcreate ${loopback_device}":
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless      => "pvs ${loopback_device}",
    refreshonly => true,
  }
  ~> exec { "vgcreate ${volume_name} ${loopback_device}":
    path        => ['/bin','/usr/bin','/sbin','/usr/sbin'],
    unless      => "vgs ${volume_name}",
    refreshonly => true,
  }
  -> Anchor['manila::service::begin']
}
