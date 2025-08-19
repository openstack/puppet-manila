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
# [*backup_mount_tmp_location*]
#   (Optional) Temporary path to create and mount shares during share backup.
#   Defaults to $facts['os_service_default'].
#
# [*check_hash*]
#   (Optional) Chooses whether hash of each file should be checked on data
#   copying.
#   Defaults to $facts['os_service_default'].
#
# [*backup_continue_update_interval*]
#   (Optional) Interval to poll to perform the next steps of backup.
#   Defaults to $facts['os_service_default'].
#
# [*restore_continue_update_interval*]
#   (Optional) Interval to poll to perform the next steps of restore.
#   Defaults to $facts['os_service_default'].
#
# [*backup_driver*]
#   (Optional) Driver to use for backups
#   Defaults to $facts['os_service_default'].
#
# [*backup_share_mount_template*]
#   (Optional) The template for mounting shares during backup.
#   Defaults to $facts['os_service_default'].
#
# [*backup_share_unmount_template*]
#   (Optional) The template for unmounting shares during backup.
#   Defaults to $facts['os_service_default'].
#
# [*backup_ignore_files*]
#   (Optional) List of files and folders to be ignored when backing up shares.
#   Defaults to $facts['os_service_default'].
#
class manila::data (
  $package_ensure                   = 'present',
  Boolean $enabled                  = true,
  Boolean $manage_service           = true,
  $mount_tmp_location               = $facts['os_service_default'],
  $backup_mount_tmp_location        = $facts['os_service_default'],
  $check_hash                       = $facts['os_service_default'],
  $backup_continue_update_interval  = $facts['os_service_default'],
  $restore_continue_update_interval = $facts['os_service_default'],
  $backup_driver                    = $facts['os_service_default'],
  $backup_share_mount_template      = $facts['os_service_default'],
  $backup_share_unmount_template    = $facts['os_service_default'],
  $backup_ignore_files              = $facts['os_service_default'],
) {
  include manila::deps
  include manila::params

  if $manila::params::data_package {
    package { 'manila-data':
      ensure => $package_ensure,
      name   => $manila::params::data_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  manila_config {
    'DEFAULT/mount_tmp_location':               value => $mount_tmp_location;
    'DEFAULT/backup_mount_tmp_location':        value => $backup_mount_tmp_location;
    'DEFAULT/check_hash':                       value => $check_hash;
    'DEFAULT/backup_continue_update_interval':  value => $backup_continue_update_interval;
    'DEFAULT/restore_continue_update_interval': value => $restore_continue_update_interval;
    'DEFAULT/backup_driver':                    value => $backup_driver;
    'DEFAULT/backup_share_mount_template':      value => $backup_share_mount_template;
    'DEFAULT/backup_share_unmount_template':    value => $backup_share_unmount_template;
    'DEFAULT/backup_ignore_files':              value => join(any2array($backup_ignore_files), ',');
  }

  if $manage_service {
    if $enabled {
      $ensure = 'running'
    } else {
      $ensure = 'stopped'
    }

    service { 'manila-data':
      ensure    => $ensure,
      name      => $manila::params::data_service,
      enable    => $enabled,
      hasstatus => true,
      tag       => 'manila-service',
    }
  }
}
