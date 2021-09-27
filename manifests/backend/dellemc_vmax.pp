# == define: manila::backend::dellemc_vmax
#
# Configures Manila to use the Dell EMC Isilon share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*emc_nas_login*]
#   (required) Administrative user account name used to access the storage
#   system.
#
# [*emc_nas_password*]
#   (required) Password for the administrative user account specified in the
#   emc_nas_login parameter.
#
# [*emc_nas_server*]
#   (required) The hostname (or IP address) for the storage system.
#
# [*emc_share_backend*]
#   (required) Share backend.
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*backend_availability_zone*]
#   (Optional) Availability zone for this share backend.
#   If not set, the storage_availability_zone option value
#   is used as the default for all backends.
#   Defaults to $::os_service_default.
#
# [*vmax_server_container*]
#   (optional) Name of the Data Mover to serve the share service.
#   Defaults to $::os_service_default
#
# [*vmax_share_data_pools*]
#   (optional)  Comma separated list specifying the name of the pools to be
#   used by this back end. Do not set this option if all storage pools on the
#   system can be used. Wild card character is supported
#   Defaults to $::os_service_default
#
# [*vmax_ethernet_ports*]
#   (optional) Comma-separated list specifying the ports (devices) of Data Mover
#   that can be used for share server interface. Do not set this option if all
#   ports on the Data Mover can be used. Wild card character is supported.
#   Defaults to $::os_service_default
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# DEPRECATED PARAMETERS
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#   managing share servers. This must be set to false if the driver is to
#   operate without managing share servers.
#   VMAX driver requires this option to be as True.
#
# === Examples
#
#  manila::backend::dellemc_vmax { 'myBackend':
#    emc_nas_login     => 'admin',
#    emc_nas_password  => 'password',
#    emc_nas_server    => <IP address of Unity Syste,>,
#    emc_share_backend => 'vmax',
#  }
#
define manila::backend::dellemc_vmax (
  $emc_nas_login,
  $emc_nas_password,
  $emc_nas_server,
  $emc_share_backend,
  $share_backend_name           = $name,
  $backend_availability_zone    = $::os_service_default,
  $vmax_server_container        = $::os_service_default,
  $vmax_share_data_pools        = $::os_service_default,
  $vmax_ethernet_ports          = $::os_service_default,
  $package_ensure               = 'present',
  # DEPRECATED PARAMETERS
  $driver_handles_share_servers = undef,
) {

  include manila::deps

  validate_legacy(String, 'validate_string', $emc_nas_password)

  if $driver_handles_share_servers != undef {
    warning('The driver_handles_share_servers parameter has been deprecated and has no effect')
  }

  $vmax_share_driver = 'manila.share.drivers.dell_emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                 value => $vmax_share_driver;
    "${share_backend_name}/driver_handles_share_servers": value => true;
    "${share_backend_name}/emc_nas_login":                value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":             value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":               value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":           value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":    value => $backend_availability_zone;
    "${share_backend_name}/emc_share_backend":            value => $emc_share_backend;
    "${share_backend_name}/vmax_server_container":        value => $vmax_server_container;
    "${share_backend_name}/vmax_share_data_pools":        value => $vmax_share_data_pools;
    "${share_backend_name}/vmax_ethernet_ports":          value => $vmax_ethernet_ports;
  }

  ensure_resource('package','nfs-utils',{
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })

}
