# ==define manila::backend::cephfsnative
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
#  Defaults to: cephfsnative
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
#   Defaults to: True
#
define manila::backend::cephfsnative (
  $driver_handles_share_servers = false,
  $share_backend_name           = $name,
  $cephfs_conf_path             = '$state_path/ceph.conf',
  $cephfs_auth_id               = 'manila',
  $cephfs_cluster_name          = 'ceph',
  $cephfs_enable_snapshots      = true,
) {

  include ::manila::deps

  $share_driver = 'manila.share.drivers.cephfs.cephfs_native.CephFSNativeDriver'

  manila_config {
    "${name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${name}/share_backend_name":           value => $share_backend_name;
    "${name}/share_driver":                 value => $share_driver;
    "${name}/cephfs_conf_path":             value => $cephfs_conf_path;
    "${name}/cephfs_auth_id":               value => $cephfs_auth_id;
    "${name}/cephfs_cluster_name":          value => $cephfs_cluster_name;
    "${name}/cephfs_enable_snapshots":      value => $cephfs_enable_snapshots;
  }
}
