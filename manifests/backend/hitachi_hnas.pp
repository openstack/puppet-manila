# == define: manila::backend::hitachi_hnas
#
# Configures Manila to use the HITACHI NAS Platform share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*hitachi_hnas_user*]
#   (required) Denotes the username credential used to manage HNAS through
#   management interface.
#
# [*hitachi_hnas_password*]
#   (required) Denotes the password credential used to manage HNAS through
#   management interface.
#
# [*hitachi_hnas_ip*]
#   (required) Denotes the IP address used to access HNAS through management
#   interface.
#
# [*hitachi_hnas_evs_id*]
#   (required) Denotes the identification number of the HNAS EVS data interface
#
# [*hitachi_hnas_evs_ip*]
#   (required) Denotes the IP address of the HNAS EVS data interface
#
# [*hitachi_hnas_file_system_name*]
#   (required) Denotes the hnas filesystem name used for volume provisioning
#
# [*driver_handles_share_servers*]
#   (optional) Denotes whether the driver should handle the responsibility of
#   managing share servers.
#   Defaults to false
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $facts['os_service_default'].
#
# [*reserved_share_percentage*]
#   (optional) The percentage of backend capacity reserved.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_from_snapshot_percentage*]
#   (optional) The percentage of backend capacity reserved. Used for shares
#   created from the snapshot.
#   Defaults to: $facts['os_service_default']
#
# [*reserved_share_extend_percentage*]
#   (optional) The percentage of backend capacity reserved for share extend
#   operation.
#   Defaults to: $facts['os_service_default']
#
# [*max_over_subscription_ratio*]
#   (optional) Float representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to: $facts['os_service_default']
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# === Examples
#
#  manila::backend::hitachi_hnas { 'HITACHI1':
#    driver_handles_share_servers => false,
#    hitachi_hnas_user => 'supervisor',
#    hitachi_hnas_password => 'supervisor',
#    hitachi_hnas_ip => '172.24.44.15',
#    hitachi_hnas_evs_id => '1',
#    hitachi_hnas_evs_ip => '10.0.1.20',
#    hitachi_hnas_file_system_name => 'FS-Manila',
#  }

define manila::backend::hitachi_hnas (
  String[1] $hitachi_hnas_user,
  String[1] $hitachi_hnas_password,
  String[1] $hitachi_hnas_ip,
  String[1] $hitachi_hnas_evs_id,
  String[1] $hitachi_hnas_evs_ip,
  $hitachi_hnas_file_system_name,
  $driver_handles_share_servers            = false,
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  $max_over_subscription_ratio             = $facts['os_service_default'],
  $package_ensure                          = 'present',
) {

  include manila::deps
  include manila::params

  $hitachi_share_driver = 'manila.share.drivers.hitachi.hds_hnas.HDSHNASDriver'

  manila_config {
    "${share_backend_name}/share_driver":                            value => $hitachi_share_driver;
    "${share_backend_name}/driver_handles_share_servers":            value => $driver_handles_share_servers;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/hitachi_hnas_user":                       value => $hitachi_hnas_user;
    "${share_backend_name}/hitachi_hnas_password":                   value => $hitachi_hnas_password, secret => true;
    "${share_backend_name}/hitachi_hnas_ip":                         value => $hitachi_hnas_ip;
    "${share_backend_name}/hitachi_hnas_evs_id":                     value => $hitachi_hnas_evs_id;
    "${share_backend_name}/hitachi_hnas_evs_ip":                     value => $hitachi_hnas_evs_ip;
    "${share_backend_name}/hitachi_hnas_file_system_name":           value => $hitachi_hnas_file_system_name;
    "${share_backend_name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${share_backend_name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${share_backend_name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
    "${share_backend_name}/max_over_subscription_ratio":             value => $max_over_subscription_ratio;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })
}
