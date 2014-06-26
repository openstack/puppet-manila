#
# == Class: manila::backend::glusterfs
#
# Configures Manila to use GlusterFS as a share driver
#
# === Parameters
#
# [*glusterfs_shares*]
#   (required) An array of GlusterFS share locations.
#   Must be an array even if there is only one share.
#
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
#
# [*glusterfs_disk_util*]
#   Removed in Icehouse.
#
# [*glusterfs_sparsed_shares*]
#   (optional) Whether or not to use sparse (thin) shares.
#   Defaults to undef which uses the driver's default of "true".
#
# [*glusterfs_mount_point_base*]
#   (optional) Where to mount the Gluster shares.
#   Defaults to undef which uses the driver's default of "$state_path/mnt".
#
# [*glusterfs_shares_config*]
#   (optional) The config file to store the given $glusterfs_shares.
#   Defaults to '/etc/manila/shares.conf'
#
# === Examples
#
# manila::backend::glusterfs { 'myGluster':
#   glusterfs_shares = ['192.168.1.1:/shares'],
# }
#
define manila::backend::glusterfs (
  $glusterfs_shares,
  $share_backend_name        = $name,
  $glusterfs_disk_util        = false,
  $glusterfs_sparsed_shares  = undef,
  $glusterfs_mount_point_base = undef,
  $glusterfs_shares_config    = '/etc/manila/shares.conf'
) {

  if $glusterfs_disk_util {
    fail('glusterfs_disk_util is removed in Icehouse.')
  }

  $content = join($glusterfs_shares, "\n")

  file { $glusterfs_shares_config:
    content => "${content}\n",
    require => Package['manila'],
    notify  => Service['manila-share']
  }

  manila_config {
    "${name}/share_backend_name":  value => $share_backend_name;
    "${name}/share_driver":        value =>
      'manila.share.drivers.glusterfs.GlusterfsDriver';
    "${name}/glusterfs_shares_config":    value => $glusterfs_shares_config;
    "${name}/glusterfs_sparsed_shares":  value => $glusterfs_sparsed_shares;
    "${name}/glusterfs_mount_point_base": value => $glusterfs_mount_point_base;
  }
}
