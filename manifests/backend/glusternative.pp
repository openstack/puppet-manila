#
# == define: manila::backend::glusternative
#
# Configures Manila to use GlusterFS native as a share driver
#
# === Parameters
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
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
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# DEPRECATED PARAMETERS
#
# [*glusterfs_native_path_to_private_key*]
#   (optional) Path of Manila host's private SSH key file. This parameter has
#   been replaced by glusterfs_path_to_private_key. Compatibility will be
#   removed in a future release.
#
define manila::backend::glusternative (
  $glusterfs_servers,
  $glusterfs_volume_pattern,
  $share_backend_name                   = $name,
  $package_ensure                       = 'present',
  $glusterfs_path_to_private_key        = undef,
  # DEPRECATED PARAMETERS
  $glusterfs_native_path_to_private_key = undef,
) {

  include manila::deps
  include manila::params

  $share_driver = 'manila.share.drivers.glusterfs_native.GlusterfsNativeShareDriver'

  if $glusterfs_native_path_to_private_key {
    warning('The glusterfs_native_path_to_private_key parameter is deprecated, use glusterfs_path_to_private_key instead')
  }

  $glusterfs_path_to_private_key_real = pick($glusterfs_path_to_private_key, $glusterfs_native_path_to_private_key)

  manila_config {
    "${share_backend_name}/share_backend_name":            value => $share_backend_name;
    "${share_backend_name}/share_driver":                  value => $share_driver;
    "${share_backend_name}/glusterfs_servers":             value => $glusterfs_servers;
    "${share_backend_name}/glusterfs_path_to_private_key": value => $glusterfs_path_to_private_key_real;
    "${share_backend_name}/glusterfs_volume_pattern":      value => $glusterfs_volume_pattern;
  }

  package { $::manila::params::gluster_package_name:
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  }
  package { $::manila::params::gluster_client_package_name:
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  }
}
