# == define: manila::backend::dellemc_vnx
#
# DEPRECATED !!
# Configures Manila to use the Dell EMC Isilon share driver
# Compatible for multiple backends
#
# === Parameters
#
# [*emc_nas_login*]
#   (required) User account name used to access the storage
#   system.
#
# [*emc_nas_password*]
#   (required) Password for the user account specified in the
#   emc_nas_login parameter.
#
# [*emc_nas_server*]
#   (required) The hostname (or IP address) for the storage system.
#
# [*emc_share_backend*]
#   (optional) Share backend.
#   Defaults to 'vnx'
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
# [*vnx_server_container*]
#   (optional) Name of the Data Mover to serve the share service.
#   Defaults to $facts['os_service_default']
#
# [*vnx_share_data_pools*]
#   (optional)  Comma separated list specifying the name of the pools to be
#   used by this back end. Do not set this option if all storage pools on the
#   system can be used. Wild card character is supported
#   Defaults to $facts['os_service_default']
#
# [*vnx_ethernet_ports*]
#   (optional) Comma-separated list specifying the ports (devices) of Data Mover
#   that can be used for share server interface. Do not set this option if all
#   ports on the Data Mover can be used. Wild card character is supported.
#   Defaults to $facts['os_service_default']
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
#   Defaults to $facts['os_service_default']
#
# [*emc_ssl_cert_path*]
#   (optional) Can be used to specify a non default path to a
#   CA_BUNDLE file or directory with certificates of trusted
#   CAs, which will be used to validate the backend.
#   Defaults to $facts['os_service_default']
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
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# DEPRECATED PARAMETERS
#
# [*driver_handles_share_servers*]
#  (optional) Denotes whether the driver should handle the responsibility of
#   managing share servers. This must be set to false if the driver is to
#   operate without managing share servers.
#   VNX driver requires this option to be as True.
#
# === Examples
#
#  manila::backend::dellemc_vnx { 'myBackend':
#    driver_handles_share_servers  => true,
#    emc_nas_login                 => 'admin',
#    emc_nas_password              => 'password',
#    emc_nas_server                => <IP address of Unity System>,
#  }
#
define manila::backend::dellemc_vnx (
  String[1] $emc_nas_login,
  String[1] $emc_nas_password,
  String[1] $emc_nas_server,
  $emc_share_backend                       = 'vnx',
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $vnx_server_container                    = $facts['os_service_default'],
  $vnx_share_data_pools                    = $facts['os_service_default'],
  $vnx_ethernet_ports                      = $facts['os_service_default'],
  $network_plugin_ipv6_enabled             = true,
  $emc_ssl_cert_verify                     = $facts['os_service_default'],
  $emc_ssl_cert_path                       = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  $package_ensure                          = 'present',
  # DEPRECATED PARAMETERS
  $driver_handles_share_servers            = undef,
) {

  include manila::deps
  include manila::params

  warning('Support for Dell EMC VNX driver has been deprecated.')

  if $driver_handles_share_servers != undef {
    warning('The driver_handles_share_servers parameter has been deprecated and has no effect')
  }

  $vnx_share_driver = 'manila.share.drivers.dell_emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                            value => $vnx_share_driver;
    "${share_backend_name}/driver_handles_share_servers":            value => true;
    "${share_backend_name}/emc_nas_login":                           value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":                        value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":                          value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":                      value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/emc_share_backend":                       value => $emc_share_backend;
    "${share_backend_name}/vnx_server_container":                    value => $vnx_server_container;
    "${share_backend_name}/vnx_share_data_pools":                    value => join(any2array($vnx_share_data_pools), ',');
    "${share_backend_name}/vnx_ethernet_ports":                      value => join(any2array($vnx_ethernet_ports), ',');
    "${share_backend_name}/network_plugin_ipv6_enabled":             value => $network_plugin_ipv6_enabled;
    "${share_backend_name}/emc_ssl_cert_verify":                     value => $emc_ssl_cert_verify;
    "${share_backend_name}/emc_ssl_cert_path":                       value => $emc_ssl_cert_path;
    "${share_backend_name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${share_backend_name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${share_backend_name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'manila-support-package' }

}

