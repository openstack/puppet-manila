# ==define manila::backend::nfs
#
# ===Paramiters
# [*share_backend_name*]
#   (optional) Allows for the share_backend_name to be separate of $name.
#   Defaults to: $name
#
#
define manila::backend::nfs (
  $share_backend_name = $name,
  $nfs_servers = [],
  $nfs_mount_options = undef,
  $nfs_disk_util = undef,
  $nfs_sparsed_shares = undef,
  $nfs_mount_point_base = undef,
  $nfs_shares_config = '/etc/manila/shares.conf',
  $nfs_used_ratio = '0.95',
  $nfs_oversub_ratio = '1.0',
) {

  file {$nfs_shares_config:
    content => join($nfs_servers, "\n"),
    require => Package['manila'],
    notify  => Service['manila-share']
  }

  manila_config {
    "${name}/share_backend_name":  value => $share_backend_name;
    "${name}/share_driver":        value =>
      'manila.share.drivers.nfs.NfsDriver';
    "${name}/nfs_shares_config":    value => $nfs_shares_config;
    "${name}/nfs_mount_options":    value => $nfs_mount_options;
    "${name}/nfs_disk_util":        value => $nfs_disk_util;
    "${name}/nfs_sparsed_shares":  value => $nfs_sparsed_shares;
    "${name}/nfs_mount_point_base": value => $nfs_mount_point_base;
    "${name}/nfs_used_ratio":       value => $nfs_used_ratio;
    "${name}/nfs_oversub_ratio":    value => $nfs_oversub_ratio;
  }
}
