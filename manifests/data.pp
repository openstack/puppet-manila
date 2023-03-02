# == Class: manila::data
#
# Install and manage Manila data.
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) The state of the data package
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) Whether to run the data service
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service
#   Defaults to true.
#
# [*mount_tmp_location*]
#   (Optional) Temporary path to create and mount shares during migration.
#   Defaults to $facts['os_service_default'].
#
# [*check_hash*]
#   (Optional) Chooses whether hash of each file should be checked on data
#   copying.
#   Defaults to $facts['os_service_default'].
#
class manila::data (
  $package_ensure     = 'present',
  $enabled            = true,
  $manage_service     = true,
  $mount_tmp_location = $facts['os_service_default'],
  $check_hash         = $facts['os_service_default'],
) {

  include manila::deps
  include manila::params

  if $::manila::params::data_package {
    package { 'manila-data':
      ensure => $package_ensure,
      name   => $::manila::params::data_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  manila_config {
    'DEFAULT/mount_tmp_location': value => $mount_tmp_location;
    'DEFAULT/check_hash':         value => $check_hash;
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'manila-data':
      ensure    => $ensure,
      name      => $::manila::params::data_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'manila-service',
    }
  }
}
