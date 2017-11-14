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
# [*cephfs_enable_snapshots*]
#   (optional) If set to True, then Manila will utilize ceph snapshots.
#   Defaults to: False
#
# [*cephfs_ganesha_server_ip*]
#   (optional) IP of a server where Ganesha service runs on.
#   Defaults to: undef
#
# [*cephfs_protocol_helper_type*]
#   (optional) Sets helper type for CephFS driver, can be CEPHFS or NFS
#   Defaults to: CEPHFS
#
define manila::backend::cephfs (
  $driver_handles_share_servers = false,
  $share_backend_name           = $name,
  $cephfs_conf_path             = '$state_path/ceph.conf',
  $cephfs_auth_id               = 'manila',
  $cephfs_cluster_name          = 'ceph',
  $cephfs_enable_snapshots      = false,
  $cephfs_protocol_helper_type  = 'CEPHFS',
  $cephfs_ganesha_server_ip     = undef,
) {

  include ::manila::deps

  $share_driver = 'manila.share.drivers.cephfs.driver.CephFSDriver'

  manila_config {
    "${name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${name}/share_backend_name":           value => $share_backend_name;
    "${name}/share_driver":                 value => $share_driver;
    "${name}/cephfs_conf_path":             value => $cephfs_conf_path;
    "${name}/cephfs_auth_id":               value => $cephfs_auth_id;
    "${name}/cephfs_cluster_name":          value => $cephfs_cluster_name;
    "${name}/cephfs_enable_snapshots":      value => $cephfs_enable_snapshots;
    "${name}/cephfs_protocol_helper_type":  value => $cephfs_protocol_helper_type;
    "${name}/cephfs_ganesha_server_ip":     value => $cephfs_ganesha_server_ip;
  }
}
