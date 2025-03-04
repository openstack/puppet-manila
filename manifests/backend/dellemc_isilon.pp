# == define: manila::backend::dellemc_isilon
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
#   (optional) Share backend.
#   Defaults to 'isilon'
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
# [*emc_nas_root_dir*]
#   (optional) The root directory where shares will be located.
#   Defaults to $facts['os_service_default']
#
# [*emc_nas_server_port*]
#   (optional)  Port number for the Dell EMC isilon server.
#   Defaults to 8080
#
# [*emc_nas_server_secure*]
#   (optional) Use secure connection to server.
#   Defaults to true
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
#
# === Examples
#
#  manila::backend::dellemc_isilon { 'myBackend':
#    emc_nas_login     => 'admin',
#    emc_nas_password  => 'password',
#    emc_nas_server    => <IP address of isilon cluster>,
#  }
#
define manila::backend::dellemc_isilon (
  String[1] $emc_nas_login,
  String[1] $emc_nas_password,
  String[1] $emc_nas_server,
  $emc_share_backend            = 'isilon',
  $share_backend_name           = $name,
  $backend_availability_zone    = $facts['os_service_default'],
  $emc_nas_root_dir             = $facts['os_service_default'],
  $emc_nas_server_port          = 8080,
  $emc_nas_server_secure        = true,
  $package_ensure               = 'present',
  # DEPRECATED PARAMETERS
  $driver_handles_share_servers = undef,
) {

  include manila::deps
  include manila::params

  if $driver_handles_share_servers != undef {
    warning('The driver_handles_share_servers parameter has been deprecated and has no effect')
  }

  $dellemc_isilon_share_driver = 'manila.share.drivers.dell_emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                 value => $dellemc_isilon_share_driver;
    "${share_backend_name}/driver_handles_share_servers": value => false;
    "${share_backend_name}/emc_nas_login":                value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":             value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":               value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":           value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":    value => $backend_availability_zone;
    "${share_backend_name}/emc_share_backend":            value => $emc_share_backend;
    "${share_backend_name}/emc_nas_root_dir":             value => $emc_nas_root_dir;
    "${share_backend_name}/emc_nas_server_port":          value => $emc_nas_server_port;
    "${share_backend_name}/emc_nas_server_secure":        value => $emc_nas_server_secure;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'manila-support-package' }
}
