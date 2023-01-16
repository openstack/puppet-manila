#
# == Define: manila::ganesha
#
# Set NFS Ganesha options for share drivers
#
# === Parameters
#
# [*share_backend_name*]
#  (optional) Name of the backend in manila.conf that
#  these settings will reside in
#  Defaults to: $name
#
# [*ganesha_config_dir*]
#  (optional) Directory where Ganesha config files are stored.
#  Defaults to $::os_service_default
#
# [*ganesha_config_path*]
#  (optional) Path to main Ganesha config file.
#  Defaults to $::os_service_default
#
# [*ganesha_service_name*]
#  (optional) Name of the ganesha nfs service.
#  Defaults to $::os_service_default
#
# [*ganesha_db_path*]
#  (optional) Location of Ganesha database file (Ganesha module only).
#  Defaults to $::os_service_default
#
# [*ganesha_export_dir*]
#  (optional) Path to directory containing Ganesha export configuration.
#  (Ganesha module only.)
#  Defaults to $::os_service_default
#
# [*ganesha_export_template_dir*]
#  (optional) Path to directory containing Ganesha export block templates.
#  (Ganesha module only.)
#  Defaults to $::os_service_default
#
# [*ganesha_rados_store_enable*]
#  (optional) Persist Ganesha exports and export counter in Ceph RADOS objects
#  Defaults to $::os_service_default
#
# [*ganesha_rados_store_pool_name*]
#  (optional) Name of the Ceph RADOS pool to store Ganesha exports and export
#  counter.
#  Defaults to $::os_service_default
#
# [*ganesha_rados_export_counter*]
#  (optional) Name of the CEPH RADOS object used as the Ganesha export counter.
#  Defaults to $::os_service_default
#
# [*ganesha_rados_export_index*]
#  (optional) Name of the CEPH RADOS object used to store a list of the export
#  RADOS object URLs.
#  Defaults to $::os_service_default
#
define manila::backend::ganesha (
  $share_backend_name            = $name,
  $ganesha_config_dir            = $::os_service_default,
  $ganesha_config_path           = $::os_service_default,
  $ganesha_service_name          = $::os_service_default,
  $ganesha_db_path               = $::os_service_default,
  $ganesha_export_dir            = $::os_service_default,
  $ganesha_export_template_dir   = $::os_service_default,
  $ganesha_rados_store_enable    = $::os_service_default,
  $ganesha_rados_store_pool_name = $::os_service_default,
  $ganesha_rados_export_counter  = $::os_service_default,
  $ganesha_rados_export_index    = $::os_service_default,
) {

  include manila::deps

  manila_config {
    "${share_backend_name}/ganesha_config_dir":            value => $ganesha_config_dir;
    "${share_backend_name}/ganesha_config_path":           value => $ganesha_config_path;
    "${share_backend_name}/ganesha_service_name":          value => $ganesha_service_name;
    "${share_backend_name}/ganesha_db_path":               value => $ganesha_db_path;
    "${share_backend_name}/ganesha_export_dir":            value => $ganesha_export_dir;
    "${share_backend_name}/ganesha_export_template_dir":   value => $ganesha_export_template_dir;
    "${share_backend_name}/ganesha_rados_store_enable":    value => $ganesha_rados_store_enable;
    "${share_backend_name}/ganesha_rados_store_pool_name": value => $ganesha_rados_store_pool_name;
    "${share_backend_name}/ganesha_rados_export_counter":  value => $ganesha_rados_export_counter;
    "${share_backend_name}/ganesha_rados_export_index":    value => $ganesha_rados_export_index;
  }

  ensure_packages( 'nfs-ganesha', {
    ensure => present,
    tag    => ['openstack', 'manila-support-package'],
  })
}
