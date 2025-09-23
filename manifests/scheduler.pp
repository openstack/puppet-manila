# == Class: manila::scheduler
#
# Install and manage Manila scheduler.
#
# === Parameters
#
# [*driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to $facts['os_service_default'].
#
# [*host_manager*]
#   (Optional) The scheduler host manager class to use
#   Defaults to $facts['os_service_default'].
#
# [*max_attempts*]
#   (Optional) Maximum number of attempts to schedule a share
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
# DEPRECATED PARAMETERS
#
# [*scheduler_driver*]
#   (Optional) Default scheduler driver to use
#   Defaults to undef
#
class manila::scheduler (
  $driver                                 = $facts['os_service_default'],
  $host_manager                           = $facts['os_service_default'],
  $max_attempts                           = $facts['os_service_default'],
  Stdlib::Ensure::Package $package_ensure = 'present',
  Boolean $enabled                        = true,
  Boolean $manage_service                 = true,
  # DEPRECATED PARAMETERS
  $scheduler_driver                       = undef
) {
  include manila::deps
  include manila::params

  if $scheduler_driver != undef {
    warning("The scheduler_driver parameter has been deprecated. \
Use the driver parameter instead")
    $driver_real = $scheduler_driver
  } else {
    $driver_real = $driver
  }

  manila_config {
    'DEFAULT/scheduler_driver':       value => $driver_real;
    'DEFAULT/scheduler_host_manager': value => $host_manager;
    'DEFAULT/scheduler_max_attempts': value => $max_attempts;
  }

  if $manila::params::scheduler_package {
    package { 'manila-scheduler':
      ensure => $package_ensure,
      name   => $manila::params::scheduler_package,
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
      name      => $manila::params::scheduler_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'manila-service',
    }
  }
}
