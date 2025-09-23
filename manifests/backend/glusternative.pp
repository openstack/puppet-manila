# == define: manila::backend::glusternative
#
# DEPRECATED !!
# Configures Manila to use GlusterFS native as a share driver
#
# === Parameters
#
# [*glusterfs_servers*]
#   (required) List of GlusterFS servers that can be used to create shares.
#   Each GlusterFS server should be of the form [remoteuser@]<volserver>, and
#   they are assumed to belong to distinct Gluster clusters.
#
# [*glusterfs_path_to_private_key*]
#   (required) Path of Manila host's private SSH key file.
#
# [*glusterfs_volume_pattern*]
#   (required) Regular expression template used to filter GlusterFS volumes for
#   share creation.
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
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
define manila::backend::glusternative (
  $glusterfs_servers,
  $glusterfs_volume_pattern,
  $glusterfs_path_to_private_key,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  Stdlib::Ensure::Package $package_ensure  = 'present',
) {
  include manila::deps
  include manila::params

  $share_driver = 'manila.share.drivers.glusterfs_native.GlusterfsNativeShareDriver'

  warning('Support for GlusterFS native driver has been deprecated.')

  manila_config {
    "${share_backend_name}/share_backend_name":                      value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/share_driver":                            value => $share_driver;
    "${share_backend_name}/glusterfs_servers":                       value => $glusterfs_servers;
    "${share_backend_name}/glusterfs_path_to_private_key":           value => $glusterfs_path_to_private_key;
    "${share_backend_name}/glusterfs_volume_pattern":                value => $glusterfs_volume_pattern;
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
