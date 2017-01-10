# == define: manila::backend::hitachi_hnas
#
# Configures Manila to use the HITACHI NAS Platform share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*driver_handles_share_servers*]
#   (required) Denotes whether the driver should handle the responsibility of
#   managing share servers. This must be set to false.
#
# [*hitachi_hnas_username*]
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
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# === Examples
#
#  manila::backend::hitachi_hnas { 'HITACHI1':
#    driver_handles_share_servers => false,
#    hitachi_hnas_username => 'supervisor',
#    hitachi_hnas_password => 'supervisor',
#    hitachi_hnas_ip => '172.24.44.15',
#    hitachi_hnas_evs_id => '1',
#    hitachi_hnas_evs_ip => '10.0.1.20',
#    hitachi_hnas_file_system_name => 'FS-Manila',
#  }

define manila::backend::hitachi_hnas (
  $hitachi_hnas_username,
  $hitachi_hnas_password,
  $hitachi_hnas_ip,
  $hitachi_hnas_evs_id,
  $hitachi_hnas_evs_ip,
  $hitachi_hnas_file_system_name,
  $driver_handles_share_servers = false,
  $share_backend_name           = $name,
  $package_ensure               = 'present',
) {

  include ::manila::deps

  validate_string($hitachi_hnas_password)

  $hitachi_share_driver = 'manila.share.drivers.hitachi.hds_hnas.HDSHNASDriver'

  manila_config {
    "${share_backend_name}/share_driver":                     value => $hitachi_share_driver;
    "${share_backend_name}/driver_handles_share_servers":     value => $driver_handles_share_servers;
    "${share_backend_name}/hitachi_hnas_username":            value => $hitachi_hnas_username;
    "${share_backend_name}/hitachi_hnas_password":            value => $hitachi_hnas_password, secret => true;
    "${share_backend_name}/hitachi_hnas_ip":                  value => $hitachi_hnas_ip;
    "${share_backend_name}/hitachi_hnas_evs_id":              value => $hitachi_hnas_evs_id;
    "${share_backend_name}/hitachi_hnas_evs_ip":              value => $hitachi_hnas_evs_ip;
    "${share_backend_name}/hitachi_hnas_file_system_name":    value => $hitachi_hnas_file_system_name;
  }

  ensure_resource('package', 'nfs-utils', {
    'ensure' => $package_ensure,
    'tag'    => 'manila-support-package',
  })
}
