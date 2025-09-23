# == define: manila::backend::glusternfs
#
# DEPRECATED !!
# Configures Manila to use GlusterFS NFS (Ganesha/GlusterNFS) as a share driver
#
# Currently Red Hat is the only supported platform, due to lack of packages
# other platforms are not yet supported.
#
# === Parameters
# [*glusterfs_target*]
#   (required) Specifies the GlusterFS volume to be mounted on the Manila host.
#   It is of the form [remoteuser@]<volserver>:/<volid>.
#
# [*glusterfs_mount_point_base*]
#   (required) Base directory containing mount points for Gluster volumes.
#
# [*glusterfs_nfs_server_type*]
#   (required) Type of NFS server that mediate access to the Gluster volumes
#   (Gluster or Ganesha).
#   Default: Gluster
#
# [*glusterfs_path_to_private_key*]
#   (required) Path of Manila host's private SSH key file.
#
# [*glusterfs_ganesha_server_ip*]
#   (required) Remote Ganesha server node's IP address.
#
# [*share_backend_name*]
#   (optional) Backend name in manila.conf where these settings will reside in.
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_share_percentage*]
#   (optional) The percentage of backend capacity reserved.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_from_snapshot_percentage*]
#   (optional) The percentage of backend capacity reserved. Used for shares
#   created from the snapshot.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_extend_percentage*]
#   (optional) The percentage of backend capacity reserved for share extend
#   operation.
#   Defaults to: $facts['os_service_default']
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
define manila::backend::glusternfs (
  $glusterfs_target,
  $glusterfs_mount_point_base,
  $glusterfs_nfs_server_type,
  $glusterfs_path_to_private_key,
  $glusterfs_ganesha_server_ip,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  Stdlib::Ensure::Package $package_ensure  = 'present',
) {
  include manila::deps
  include manila::params

  $share_driver = 'manila.share.drivers.glusterfs.GlusterfsShareDriver'

  warning('Support for GlusterFS driver has been deprecated.')

  manila_config {
    "${share_backend_name}/share_backend_name":                      value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/share_driver":                            value => $share_driver;
    "${share_backend_name}/glusterfs_target":                        value => $glusterfs_target;
    "${share_backend_name}/glusterfs_mount_point_base":              value => $glusterfs_mount_point_base;
    "${share_backend_name}/glusterfs_nfs_server_type":               value => $glusterfs_nfs_server_type;
    "${share_backend_name}/glusterfs_path_to_private_key":           value => $glusterfs_path_to_private_key;
    "${share_backend_name}/glusterfs_ganesha_server_ip":             value => $glusterfs_ganesha_server_ip;
    "${share_backend_name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${share_backend_name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${share_backend_name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
  }

  stdlib::ensure_packages([
    $manila::params::gluster_package_name,
    $manila::params::gluster_client_package_name,
  ], {
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })
}
