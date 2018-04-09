# == define: manila::backend::dellemc_unity
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
#   Unity driver requires this option to be as True.
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
# [*unity_server_meta_pool*]
#   (optional) The name of the pool to persist the meta-data of NAS server.
#   Defaults to None
#
# [*unity_share_data_pools*]
#   (optional)  Comma separated list specifying the name of the pools to be
#   used by this back end. Do not set this option if all storage pools on the
#   system can be used. Wild card character is supported
#   Defaults to None
#
# [*unity_ethernet_ports*]
#   (optional) Comma separated list specifying the ethernet ports of Unity
#   system that can be used for share. Do not set this option if all ethernet
#   ports can be used. Wild card character is supported. Both the normal ethernet
#   port and link aggregation port can be used by Unity share driver.
#   Defaults to None
#
# [*network_plugin_ipv6_enabled*]
#   (optional) Whether to support IPv6 network resource, Default=False.
#   If this option is True, both IPv4 and IPv6 are supported.
#   If this option is False, only IPv4 is supported.
#   Defaults to true
#
# [*emc_ssl_cert_verify*]
#   (optional) If set to False the https client will not validate the
#   SSL certificate of the backend endpoint.
#   Defaults to false
#
# [*emc_ssl_cert_path*]
#   (optional) Can be used to specify a non default path to a
#   CA_BUNDLE file or directory with certificates of trusted
#   CAs, which will be used to validate the backend.
#   Defaults to None
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# === Examples
#
#  manila::backend::dellemc_unity { 'myBackend':
#    driver_handles_share_servers  => true,
#    emc_nas_login                 => 'admin',
#    emc_nas_password              => 'password',
#    emc_nas_server                => <IP address of Unity Syste,>,
#    emc_share_backend             => 'unity',
#  }
#
define manila::backend::dellemc_unity (
  $driver_handles_share_servers,
  $emc_nas_login,
  $emc_nas_password,
  $emc_nas_server,
  $emc_share_backend,
  $share_backend_name           = $name,
  $unity_server_meta_pool       = undef,
  $unity_share_data_pools       = undef,
  $unity_ethernet_ports         = undef,
  $network_plugin_ipv6_enabled  = true,
  $emc_ssl_cert_verify          = false,
  $emc_ssl_cert_path            = undef,
  $package_ensure               = 'present',
) {

  include ::manila::deps

  validate_string($emc_nas_password)

  $unity_share_driver = 'manila.share.drivers.emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                 value => $unity_share_driver;
    "${share_backend_name}/driver_handles_share_servers": value => $driver_handles_share_servers;
    "${share_backend_name}/emc_nas_login":                value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":             value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":               value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":           value => $share_backend_name;
    "${share_backend_name}/emc_share_backend":            value => $emc_share_backend;
    "${share_backend_name}/unity_server_meta_pool":       value => $unity_server_meta_pool;
    "${share_backend_name}/unity_share_data_pools":       value => $unity_share_data_pools;
    "${share_backend_name}/unity_ethernet_ports":         value => $unity_ethernet_ports;
    "${share_backend_name}/network_plugin_ipv6_enabled":  value => $network_plugin_ipv6_enabled;
    "${share_backend_name}/emc_ssl_cert_verify":          value => $emc_ssl_cert_verify;
    "${share_backend_name}/emc_ssl_cert_path":            value => $emc_ssl_cert_path;
  }

  ensure_resource('package','nfs-utils',{
    ensure => $package_ensure,
    tag    => 'manila-support-package',
  })

  # Python library storops is required to run Unity driver.
  package{'storops':
    ensure   => $package_ensure,
    provider => 'pip',
  }
}
