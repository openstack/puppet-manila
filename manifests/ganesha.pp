#
# == Class: manila::ganesha
#
# Class to set NFS Ganesha options for share drivers
#
# === Parameters
# [*ganesha_config_dir*]
#   (optional) Directory where Ganesha config files are stored.
#   Defaults to $::os_service_default
#
# [*ganesha_config_path*]
#   (optional) Path to main Ganesha config file.
#   Defaults to $::os_service_default
#
# [*ganesha_service_name*]
#   (optional) Name of the ganesha nfs service.
#   Defaults to $::os_service_default
#
# [*ganesha_db_path*]
#   (optional) Location of Ganesha database file (Ganesha module only).
#   Defaults to $::os_service_default
#
# [*ganesha_export_dir*]
#   (optional) Path to directory containing Ganesha export configuration.
#   (Ganesha module only.)
#   Defaults to $::os_service_default
#
# [*ganesha_export_template_dir*]
#   (optional) Path to directory containing Ganesha export block templates.
#   (Ganesha module only.)
#   Defaults to $::os_service_default
#
class manila::ganesha (
  $ganesha_config_dir          = $::os_service_default,
  $ganesha_config_path         = $::os_service_default,
  $ganesha_service_name        = $::os_service_default,
  $ganesha_db_path             = $::os_service_default,
  $ganesha_export_dir          = $::os_service_default,
  $ganesha_export_template_dir = $::os_service_default,
) {

  include manila::deps

  manila_config {
    'DEFAULT/ganesha_config_dir':          value => $ganesha_config_dir;
    'DEFAULT/ganesha_config_path':         value => $ganesha_config_path;
    'DEFAULT/ganesha_service_name':        value => $ganesha_service_name;
    'DEFAULT/ganesha_db_path':             value => $ganesha_db_path;
    'DEFAULT/ganesha_export_dir':          value => $ganesha_export_dir;
    'DEFAULT/ganesha_export_template_dir': value => $ganesha_export_template_dir;
  }

  if ($::osfamily == 'RedHat') {
    package { 'nfs-ganesha':
      ensure => present,
      tag    => ['openstack', 'manila-support-package'],
    }
  } else {
    warning("Unsupported osfamily ${::osfamily}, Red Hat is the only supported platform.")
  }
}
