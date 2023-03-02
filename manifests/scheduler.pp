# == Class: manila::scheduler
#
# Install and manage Manila scheduler.
#
# === Parameters
#
# [*scheduler_driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to $facts['os_service_default'].
#
# [*package_ensure*]
#   (Optional) The state of the scheduler package
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) Whether to run the scheduler service
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether to start/stop the service
#   Defaults to true.
#
class manila::scheduler (
  $scheduler_driver = $facts['os_service_default'],
  $package_ensure   = 'present',
  $enabled          = true,
  $manage_service   = true
) {

  include manila::deps
  include manila::params

  if $scheduler_driver {
    manila_config {
      'DEFAULT/scheduler_driver': value => $scheduler_driver
    }
  } else {
    warning("Using a false value for scheduler_driver is deprecated. \
Use the os_service_default fact instead.")
    manila_config {
      'DEFAULT/scheduler_driver': value => $facts['os_service_default']
    }
  }

  if $::manila::params::scheduler_package {
    package { 'manila-scheduler':
      ensure => $package_ensure,
      name   => $::manila::params::scheduler_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'manila-scheduler':
      ensure    => $ensure,
      name      => $::manila::params::scheduler_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'manila-service',
    }
  }
}
