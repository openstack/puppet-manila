#
# == Class: manila::share::glusterfs
#
# Configures Manila to use GlusterFS as a share driver
#
# === Parameters
#
# [*glusterfs_shares*]
#   (required) An array of GlusterFS share locations.
#   Must be an array even if there is only one share.
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
# class { 'manila::share::glusterfs':
#   glusterfs_shares = ['192.168.1.1:/shares'],
# }
#
class manila::share::glusterfs (
  $glusterfs_shares,
  $glusterfs_disk_util        = false,
  $glusterfs_sparsed_shares   = undef,
  $glusterfs_mount_point_base = undef,
  $glusterfs_shares_config    = '/etc/manila/shares.conf'
) {

  manila::backend::glusterfs { 'DEFAULT':
    glusterfs_shares           => $glusterfs_shares,
    glusterfs_disk_util        => $glusterfs_disk_util,
    glusterfs_sparsed_shares   => $glusterfs_sparsed_shares,
    glusterfs_mount_point_base => $glusterfs_mount_point_base,
    glusterfs_shares_config    => $glusterfs_shares_config,
  }
}
