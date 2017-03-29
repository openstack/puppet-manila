# == Class: manila::share::hitachi_hnas
#
# Configures Manila to use the HITACHI NAS platform share driver
#
# === Parameters
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
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*hitachi_hnas_file_system_name*]
#   (required) Denotes the hnas filesystem name used for volume provisioning
#
# === Examples
#
#  manila::backend::hds_hnas { 'HITACHI1':
#    driver_handles_share_servers => false,
#    hitachi_hnas_username => 'supervisor',
#    hitachi_hnas_password => 'supervisor',
#    hitachi_hnas_ip => '172.24.44.15',
#    hitachi_hnas_evs_id => '1',
#    hitachi_hnas_evs_ip => '10.0.1.20',
#    hitachi_hnas_file_system_name => 'FS-Manila',
#  }
#
class manila::share::hitachi_hnas (
    $hitachi_hnas_username,
    $hitachi_hnas_password,
    $hitachi_hnas_ip,
    $hitachi_hnas_evs_id,
    $hitachi_hnas_evs_ip,
    $hitachi_hnas_file_system_name,
    $driver_handles_share_servers = false,
    $share_backend_name           = $name,
) {

  manila::backend::hitachi_hnas { 'DEFAULT':
    driver_handles_share_servers  => $driver_handles_share_servers,
    hitachi_hnas_username         => $hitachi_hnas_username,
    hitachi_hnas_password         => $hitachi_hnas_password,
    hitachi_hnas_ip               => $hitachi_hnas_ip,
    hitachi_hnas_evs_id           => $hitachi_hnas_evs_id,
    hitachi_hnas_evs_ip           => $hitachi_hnas_evs_ip,
    hitachi_hnas_file_system_name => $hitachi_hnas_file_system_name,
  }
}
