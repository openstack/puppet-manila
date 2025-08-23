# == Class: manila::share
#
# === Parameters
#
# [*package_ensure*]
#   (Optional) Ensure State for package
#   Defaults to 'present'.
#
# [*enabled*]
#   (Optional) Should the service be enabled
#   Defaults to true.
#
# [*manage_service*]
#   (Optional) Whether the service should be managed by Puppet
#   Defaults to true.
#
# [*delete_share_server_with_last_share*]
#   (Optional) Wheather share servers will be deleted on deletion of the last
#   share.
#   Defaults to $facts['os_service_default'].
#
# [*unmanage_remove_access_rules*]
#   (Optional) Deny access and remove all access rules on share unmanage.
#   Defaults to $facts['os_service_default'].
#
# [*automatic_share_server_cleanup*]
#   (Optional) Delete all share servers which were unused more than specified
#   time.
#   Defaults to $facts['os_service_default'].
#
# [*unused_share_server_cleanup_interval*]
#   (Optional) Unallocated share servers reclamation time interval (minutes).
#   Defaults to $facts['os_service_default'].
#
# [*replica_state_update_interval*]
#   (Optional) Interval to poll for the health of each replica instance.
#   Defaults to $facts['os_service_default'].
#
# [*migration_driver_continue_update_interval*]
#   (Optional) Interval to poll the driver to perform the next step of
#   migration in the storage backend, for a migration share.
#   Defaults to $facts['os_service_default'].
#
# [*server_migration_driver_continue_update_interval*]
#   (Optional) Interval to poll the driver to perform the next step of
#   migration in the storage backend, for a migration share server.
#   Defaults to $facts['os_service_default'].
#
# [*share_usage_size_update_interval*]
#   (Optional) Interval to poll the driver to update the share usage size in
#   the storage backend.
#   Defaults to $facts['os_service_default'].
#
# [*enable_gathering_share_usage_size*]
#   (Optional) Poll share usage size. Usage data can be consumed by telemetry
#   integration.
#   Defaults to $facts['os_service_default'].
#
# [*share_service_inithost_offload*]
#   (Optional) Offload pending share ensure during share service startup.
#   Defaults to $facts['os_service_default'].
#
# [*check_for_expired_shares_in_recycle_bin_interval*]
#   (Optional) Interval to check for expired shares and delete them from
#   the Recycle bin.
#   Defaults to $facts['os_service_default'].
#
# [*check_for_expired_transfers*]
#   (Optional) Interval to check for expired transfers and destroy them and
#   roll back share state.
#   Defaults to $facts['os_service_default'].
#
# [*driver_backup_continue_update_interval*]
#   (Optional) Interval to poll to perform the next steps of backup.
#   Defaults to $facts['os_service_default'].
#
# [*driver_restore_continue_update_interval*]
#   (Optional) Interval to poll to perform the next steps of restore.
#   Defaults to $facts['os_service_default'].
#
class manila::share (
  $package_ensure                                   = 'present',
  Boolean $enabled                                  = true,
  Boolean $manage_service                           = true,
  $delete_share_server_with_last_share              = $facts['os_service_default'],
  $unmanage_remove_access_rules                     = $facts['os_service_default'],
  $automatic_share_server_cleanup                   = $facts['os_service_default'],
  $unused_share_server_cleanup_interval             = $facts['os_service_default'],
  $replica_state_update_interval                    = $facts['os_service_default'],
  $migration_driver_continue_update_interval        = $facts['os_service_default'],
  $server_migration_driver_continue_update_interval = $facts['os_service_default'],
  $share_usage_size_update_interval                 = $facts['os_service_default'],
  $enable_gathering_share_usage_size                = $facts['os_service_default'],
  $share_service_inithost_offload                   = $facts['os_service_default'],
  $check_for_expired_shares_in_recycle_bin_interval = $facts['os_service_default'],
  $check_for_expired_transfers                      = $facts['os_service_default'],
  $driver_backup_continue_update_interval           = $facts['os_service_default'],
  $driver_restore_continue_update_interval          = $facts['os_service_default'],
) {
  include manila::deps
  include manila::params

  if $manila::params::share_package {
    package { 'manila-share':
      ensure => $package_ensure,
      name   => $manila::params::share_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  manila_config {
    'DEFAULT/delete_share_server_with_last_share':              value => $delete_share_server_with_last_share;
    'DEFAULT/unmanage_remove_access_rules':                     value => $unmanage_remove_access_rules;
    'DEFAULT/automatic_share_server_cleanup':                   value => $automatic_share_server_cleanup;
    'DEFAULT/unused_share_server_cleanup_interval':             value => $unused_share_server_cleanup_interval;
    'DEFAULT/replica_state_update_interval':                    value => $replica_state_update_interval;
    'DEFAULT/migration_driver_continue_update_interval':        value => $migration_driver_continue_update_interval;
    'DEFAULT/server_migration_driver_continue_update_interval': value => $server_migration_driver_continue_update_interval;
    'DEFAULT/share_usage_size_update_interval':                 value => $share_usage_size_update_interval;
    'DEFAULT/enable_gathering_share_usage_size':                value => $enable_gathering_share_usage_size;
    'DEFAULT/share_service_inithost_offload':                   value => $share_service_inithost_offload;
    'DEFAULT/check_for_expired_shares_in_recycle_bin_interval': value => $check_for_expired_shares_in_recycle_bin_interval;
    'DEFAULT/check_for_expired_transfers':                      value => $check_for_expired_transfers;
    'DEFAULT/driver_backup_continue_update_interval':           value => $driver_backup_continue_update_interval;
    'DEFAULT/driver_restore_continue_update_interval':          value => $driver_restore_continue_update_interval;
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'manila-share':
      ensure    => $ensure,
      name      => $manila::params::share_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'manila-service',
    }
  }
}
