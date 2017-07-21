# == define: manila::backend::dellemc_isilon
#
# Configures Manila to use the Dell EMC Isilon share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*driver_handles_share_servers*]
#  (required) Denotes whether the driver should handle the responsibility of
#   managing share servers. This must be set to false if the driver is to
#   operate without managing share servers.
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
#   Defaults to http
#
# [*share_backend_name*]
#   (optional) Name of the backend in manila.conf that
#   these settings will reside in
#
# [*emc_nas_root_dir*]
#   (optional) The root directory where shares will be located.
#   Defaults to None
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
# === Examples
#
#  manila::backend::dellemc_isilon { 'myBackend':
#    driver_handles_share_servers  => false,
#    emc_nas_login                 => 'admin',
#    emc_nas_password              => 'password',
#    emc_nas_server                => <IP address of isilon cluster>,
#    emc_share_backend             => 'isilon',
#  }
#
define manila::backend::dellemc_isilon (
  $driver_handles_share_servers,
  $emc_nas_login,
  $emc_nas_password,
  $emc_nas_server,
  $emc_share_backend,
  $share_backend_name        = $name,
  $emc_nas_root_dir          = undef,
  $emc_nas_server_port       = 8080,
  $emc_nas_server_secure     = true,
  $package_ensure            = 'present',
) {

  include ::manila::deps

  validate_string($emc_nas_password)

  $dellemc_isilon_share_driver = 'manila.share.drivers.emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                 value => $dellemc_isilon_share_driver;
    "${share_backend_name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${share_backend_name}/emc_nas_login":                value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":             value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":               value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":           value => $share_backend_name;
    "${share_backend_name}/emc_share_backend":            value => $emc_share_backend;
    "${share_backend_name}/emc_nas_root_dir":             value => $emc_nas_root_dir;
    "${share_backend_name}/emc_nas_server_port":          value => $emc_nas_server_port;
    "${share_backend_name}/emc_nas_server_secure":        value => $emc_nas_server_secure;
  }

  ensure_resource('package','nfs-utils',{
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })
}
