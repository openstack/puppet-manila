# ==define manila::backend::cephfs
#
# === Parameters
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#  managing share servers. This must be set to false if the driver is to
#  operate without managing share servers.
#  Defaults to: False
#
# [*share_backend_name*]
#  (optional) Name of the backend in manila.conf that
#  these settings will reside in
#  Defaults to: $name
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*cephfs_conf_path*]
#   (optional) Path to cephfs config.
#   Defaults to: $state_path/ceph.conf
#
# [*cephfs_auth_id*]
#   (optional) cephx user id for Manila
#   Defaults to: manila
#
# [*cephfs_cluster_name*]
#   (optional) Name of the cephfs cluster the driver will connect to.
#   Defaults to: ceph
#
# [*cephfs_ganesha_server_ip*]
#   (optional) IP of a server where Ganesha service runs on.
#   Defaults to: $facts['os_service_default']
#
# [*cephfs_ganesha_export_ips*]
#   (optional) List of IPs on which Ganesha provides NFS share service.
#   Defaults to: $facts['os_service_default']
#
# [*cephfs_nfs_cluster_id*]
#   (optional) ID of the NFS cluster to use (when using ceph orchestrator
#   deployed clustered NFS service)
#   Defaults to: $facts['os_service_default']
#
# [*cephfs_volume_mode*]
#   (optional) octal rwx permissions for CephFS backing volumes,
#   snapshots, and groups of volumes and snapshots.
#   Defaults to $facts['os_service_default']
#
# [*cephfs_protocol_helper_type*]
#   (optional) Sets helper type for CephFS driver, can be CEPHFS or NFS
#   Defaults to: CEPHFS
#
# [*cephfs_filesystem_name*]
#   (optional) The name of the filesystem to use, if there are multiple
#   filesystems in the cluster.
#   Defaults to: $facts['os_service_default']
#
# [*cephfs_cached_allocated_capacity_update_interval*]
#   (optional) The maximum time in seconds that the cached pool data will be
#   considered updated.
#   Defaults to: $facts['os_service_default']
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
# [*manage_package*]
#   (optional) Ensures ceph client package is installed if true.
#   Defaults to: true
#
# DEPRECATED PARAMETERS
#
# [*cephfs_ganesha_server_is_remote*]
#   (required) Whether the Ganesha service is remote or colocated on the
#   same node where the Share service runs.
#   Defaults to: undef
#
# [*cephfs_ganesha_server_username*]
#   (optional) The username to use when logging on the remote node
#   hosting the Ganesha service
#   Defaults to: undef
#
# [*cephfs_ganesha_server_password*]
#   (optional) The password to use when logging on the remote node
#   hosting the Ganesha service
#   Defaults to: undef
#
# [*cephfs_ganesha_path_to_private_key*]
#   (optional) The secret key to use when logging on the remote node
#   hosting the Ganesha service (prevails on server_password)
#   Defaults to: undef
#
define manila::backend::cephfs (
  $driver_handles_share_servers                     = false,
  $share_backend_name                               = $name,
  $backend_availability_zone                        = $facts['os_service_default'],
  $cephfs_conf_path                                 = '$state_path/ceph.conf',
  $cephfs_auth_id                                   = 'manila',
  $cephfs_cluster_name                              = 'ceph',
  $cephfs_ganesha_server_ip                         = $facts['os_service_default'],
  $cephfs_ganesha_export_ips                        = $facts['os_service_default'],
  $cephfs_nfs_cluster_id                            = $facts['os_service_default'],
  $cephfs_volume_mode                               = $facts['os_service_default'],
  $cephfs_protocol_helper_type                      = 'CEPHFS',
  $cephfs_filesystem_name                           = $facts['os_service_default'],
  $cephfs_cached_allocated_capacity_update_interval = $facts['os_service_default'],
  $reserved_share_percentage                        = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage          = $facts['os_service_default'],
  $reserved_share_extend_percentage                 = $facts['os_service_default'],
  Boolean $manage_package                           = true,
  # DEPRECATED PARAMETERS
  $cephfs_ganesha_server_is_remote                  = undef,
  $cephfs_ganesha_server_username                   = undef,
  $cephfs_ganesha_server_password                   = undef,
  $cephfs_ganesha_path_to_private_key               = undef,
) {

  include manila::deps
  include manila::params

  [
    'cephfs_ganesha_server_is_remote',
    'cephfs_ganesha_server_username',
    'cephfs_ganesha_server_password',
    'cephfs_ganesha_path_to_private_key'
  ].each |String $opt| {
    if getvar($opt) != undef {
      warning("The ${opt} parameter has been deprecated and will be removed.")
    }
  }

  $share_driver = 'manila.share.drivers.cephfs.driver.CephFSDriver'

  manila_config {
    "${name}/driver_handles_share_servers":                     value => $driver_handles_share_servers;
    "${name}/share_backend_name":                               value => $share_backend_name;
    "${name}/backend_availability_zone":                        value => $backend_availability_zone;
    "${name}/share_driver":                                     value => $share_driver;
    "${name}/cephfs_conf_path":                                 value => $cephfs_conf_path;
    "${name}/cephfs_auth_id":                                   value => $cephfs_auth_id;
    "${name}/cephfs_cluster_name":                              value => $cephfs_cluster_name;
    "${name}/cephfs_ganesha_server_ip":                         value => $cephfs_ganesha_server_ip;
    "${name}/cephfs_ganesha_export_ips":                        value => join(any2array($cephfs_ganesha_export_ips), ',');
    "${name}/cephfs_nfs_cluster_id":                            value => $cephfs_nfs_cluster_id;
    "${name}/cephfs_volume_mode":                               value => $cephfs_volume_mode;
    "${name}/cephfs_protocol_helper_type":                      value => $cephfs_protocol_helper_type;
    "${name}/cephfs_filesystem_name":                           value => $cephfs_filesystem_name;
    "${name}/cephfs_cached_allocated_capacity_update_interval": value => $cephfs_cached_allocated_capacity_update_interval;
    "${name}/reserved_share_percentage":                        value => $reserved_share_percentage;
    "${name}/reserved_share_from_snapshot_percentage":          value => $reserved_share_from_snapshot_percentage;
    "${name}/reserved_share_extend_percentage":                 value => $reserved_share_extend_percentage;
  }

  manila_config {
    "${name}/cephfs_ganesha_server_is_remote":
      value => pick($cephfs_ganesha_server_is_remote, $facts['os_service_default']);
    "${name}/cephfs_ganesha_server_username":
      value => pick($cephfs_ganesha_server_username, $facts['os_service_default']);
    "${name}/cephfs_ganesha_server_password":
      value => pick($cephfs_ganesha_server_password, $facts['os_service_default']), secret => true;
    "${name}/cephfs_ganesha_path_to_private_key":
      value => pick($cephfs_ganesha_path_to_private_key, $facts['os_service_default']);
  }

  if $manage_package {
    ensure_packages( 'ceph-common', {
      ensure => present,
      name   => $::manila::params::ceph_common_package_name,
    })
    Package<| title == 'ceph-common' |> { tag +> 'manila-support-package' }
  }

}
