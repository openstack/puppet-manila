# == Class: manila::share::hitachi_hnas
#
# Configures Manila to use the HITACHI NAS platform share driver
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
#   Defaults to false.
#
# DEPRECATED PARAMETERS
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# === Examples
#
#  manila::backend::hds_hnas { 'HITACHI1':
#    driver_handles_share_servers => false,
#    hitachi_hnas_user => 'supervisor',
#    hitachi_hnas_password => 'supervisor',
#    hitachi_hnas_ip => '172.24.44.15',
#    hitachi_hnas_evs_id => '1',
#    hitachi_hnas_evs_ip => '10.0.1.20',
#    hitachi_hnas_file_system_name => 'FS-Manila',
#  }
#
class manila::share::hitachi_hnas (
  $hitachi_hnas_user,
  $hitachi_hnas_password,
  $hitachi_hnas_ip,
  $hitachi_hnas_evs_id,
  $hitachi_hnas_evs_ip,
  $hitachi_hnas_file_system_name,
  $driver_handles_share_servers = false,
  # DEPRECAED PARAMETERS
  $share_backend_name           = undef,
) {

  if $share_backend_name != undef {
    warning('The share_backend_name parameter is deprecated and has no effect.')
  }

  manila::backend::hitachi_hnas { 'DEFAULT':
    driver_handles_share_servers  => $driver_handles_share_servers,
    hitachi_hnas_user             => $hitachi_hnas_user,
    hitachi_hnas_password         => $hitachi_hnas_password,
    hitachi_hnas_ip               => $hitachi_hnas_ip,
    hitachi_hnas_evs_id           => $hitachi_hnas_evs_id,
    hitachi_hnas_evs_ip           => $hitachi_hnas_evs_ip,
    hitachi_hnas_file_system_name => $hitachi_hnas_file_system_name,
  }
}
