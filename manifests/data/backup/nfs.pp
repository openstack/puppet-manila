# == Class: manila::data::backup::nfs
#
# Setup Manila to backup shares into NFS
#
# === Parameters
#
# [*backup_mount_export*]
#   (Required) NFS backup export location.
#   Defaults to $facts['os_service_default']
#
# [*backup_mount_template*]
#   (Optional) The template for mounting NFS shares.
#   Defaults to $facts['os_service_default']
#
# [*backup_unmount_template*]
#   (Optional) The template for unmounting NFS shares.
#   Defaults to $facts['os_service_default']
#
# [*backup_mount_proto*]
#   (Optional) Mount Protocol for mounting NFS shares.
#   Defaults to $facts['os_service_default']
#
# [*backup_mount_options*]
#   (Optional) Mount ptions passed to the NFS client.
#   Defaults to $facts['os_service_default']
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
class manila::data::backup::nfs (
  String[1] $backup_mount_export,
  $backup_mount_template   = $facts['os_service_default'],
  $backup_unmount_template = $facts['os_service_default'],
  $backup_mount_proto      = $facts['os_service_default'],
  $backup_mount_options    = $facts['os_service_default'],
  $package_ensure          = 'present',
) {
  include manila::deps
  include manila::params

  manila_config {
    'DEFAULT/backup_mount_template':   value => $backup_mount_template;
    'DEFAULT/backup_unmount_template': value => $backup_unmount_template;
    'DEFAULT/backup_mount_export':     value => $backup_mount_export;
    'DEFAULT/backup_mount_proto':      value => $backup_mount_proto;
    'DEFAULT/backup_mount_options':    value => $backup_mount_options;
  }

  stdlib::ensure_packages('nfs-client', {
    name   => $manila::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'manila-support-package' }
}
