#
# == Class: manila::backend::glusterfs
#
# Configures Manila to use GlusterFS as a share driver
#
# === Parameters
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*glusterfs_volumes_config*]
#   (required) File with the list of Gluster volumes that can be used to
#   create shares
#   Default to: /etc/manila/glusterfs_volumes
#
# [*glusterfs_mount_point_base*]
#   (optional) Base dir containing mount points for Gluster volumes.
#   Defaults to: $state_path/mnt
#
# === Examples
# manila::backend::glusterfs { 'myGluster':
#   glusterfs_shares = ['192.168.1.1:/shares'],
# }
#
define manila::backend::glusterfs (
  $share_backend_name         = $name,
  $backend_availability_zone  = $::os_service_default,
  $glusterfs_volumes_config   = '/etc/manila/glusterfs_volumes',
  $glusterfs_mount_point_base = '$state_path/mnt',
) {

  include manila::deps
  $share_driver = 'manila.share.drivers.glusterfs.GlusterfsShareDriver'

  manila_config {
    "${name}/share_backend_name":          value => $share_backend_name;
    "${name}/backend_availability_zone":   value => $backend_availability_zone;
    "${name}/share_driver":                value => $share_driver;
    "${name}/glusterfs_volumes_config":    value => $glusterfs_volumes_config;
    "${name}/glusterfs_mount_point_base":  value => $glusterfs_mount_point_base;
  }
}
