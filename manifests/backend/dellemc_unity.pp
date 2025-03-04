# == define: manila::backend::dellemc_unity
#
# Configures Manila to use the Dell EMC Unity share driver
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
# [*unity_server_meta_pool*]
#   (required) The name of the pool to persist the meta-data of NAS server.
#
# [*emc_share_backend*]
#   (optional) Share backend.
#   Defaults to 'unity'
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
# [*unity_share_data_pools*]
#   (optional)  Comma separated list specifying the name of the pools to be
#   used by this back end. Do not set this option if all storage pools on the
#   system can be used. Wild card character is supported
#   Defaults to $facts['os_service_default']
#
# [*unity_ethernet_ports*]
#   (optional) Comma separated list specifying the ethernet ports of Unity
#   system that can be used for share. Do not set this option if all ethernet
#   ports can be used. Wild card character is supported. Both the normal ethernet
#   port and link aggregation port can be used by Unity share driver.
#   Defaults to $facts['os_service_default']
#
# [*unity_share_server*]
#   (optional) NAS server used for creating share when driver is in DHSS=False
#   mode. It is required when driver_handles_share_servers=False in manila.conf.
#   Defaults to $facts['os_service_default']
#
# [*report_default_filter_function*]
#   (optional) Whether or not report default filter function.
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
# [*max_over_subscription_ratio*]
#   (optional) Float representation of the over subscription ratio when thin
#   provisionig is involved.
#   Defaults to: $facts['os_service_default']
#
# [*package_ensure*]
#   (optional) Ensure state for package. Defaults to 'present'.
#
# [*manage_storops*]
#   (optional) Manage the storops python library.
#   Defaults to true
#
# === Examples
#
#  manila::backend::dellemc_unity { 'myBackend':
#    driver_handles_share_servers  => true,
#    emc_nas_login                 => 'admin',
#    emc_nas_password              => 'password',
#    emc_nas_server                => <IP address of Unity System>,
#    emc_share_backend             => 'unity',
#  }
#
define manila::backend::dellemc_unity (
  $driver_handles_share_servers,
  String[1] $emc_nas_login,
  String[1] $emc_nas_password,
  String[1] $emc_nas_server,
  String[1] $unity_server_meta_pool,
  $emc_share_backend                       = 'unity',
  $share_backend_name                      = $name,
  $backend_availability_zone               = $facts['os_service_default'],
  $unity_share_data_pools                  = $facts['os_service_default'],
  $unity_ethernet_ports                    = $facts['os_service_default'],
  $unity_share_server                      = $facts['os_service_default'],
  $report_default_filter_function          = $facts['os_service_default'],
  $network_plugin_ipv6_enabled             = true,
  $emc_ssl_cert_verify                     = $facts['os_service_default'],
  $emc_ssl_cert_path                       = $facts['os_service_default'],
  $reserved_share_percentage               = $facts['os_service_default'],
  $reserved_share_from_snapshot_percentage = $facts['os_service_default'],
  $reserved_share_extend_percentage        = $facts['os_service_default'],
  $max_over_subscription_ratio             = $facts['os_service_default'],
  $package_ensure                          = 'present',
  Boolean $manage_storops                  = true,
) {

  include manila::deps
  include manila::params

  $unity_share_driver = 'manila.share.drivers.dell_emc.driver.EMCShareDriver'

  manila_config {
    "${share_backend_name}/share_driver":                            value => $unity_share_driver;
    "${share_backend_name}/driver_handles_share_servers":            value => $driver_handles_share_servers;
    "${share_backend_name}/emc_nas_login":                           value => $emc_nas_login;
    "${share_backend_name}/emc_nas_password":                        value => $emc_nas_password, secret => true;
    "${share_backend_name}/emc_nas_server":                          value => $emc_nas_server;
    "${share_backend_name}/share_backend_name":                      value => $share_backend_name;
    "${share_backend_name}/backend_availability_zone":               value => $backend_availability_zone;
    "${share_backend_name}/emc_share_backend":                       value => $emc_share_backend;
    "${share_backend_name}/unity_server_meta_pool":                  value => $unity_server_meta_pool;
    "${share_backend_name}/unity_share_data_pools":                  value => join(any2array($unity_share_data_pools), ',');
    "${share_backend_name}/unity_ethernet_ports":                    value => join(any2array($unity_ethernet_ports), ',');
    "${share_backend_name}/unity_share_server":                      value => $unity_share_server;
    "${share_backend_name}/report_default_filter_function":          value => $report_default_filter_function;
    "${share_backend_name}/network_plugin_ipv6_enabled":             value => $network_plugin_ipv6_enabled;
    "${share_backend_name}/emc_ssl_cert_verify":                     value => $emc_ssl_cert_verify;
    "${share_backend_name}/emc_ssl_cert_path":                       value => $emc_ssl_cert_path;
    "${share_backend_name}/reserved_share_percentage":               value => $reserved_share_percentage;
    "${share_backend_name}/reserved_share_from_snapshot_percentage": value => $reserved_share_from_snapshot_percentage;
    "${share_backend_name}/reserved_share_extend_percentage":        value => $reserved_share_extend_percentage;
    "${share_backend_name}/max_over_subscription_ratio":             value => $max_over_subscription_ratio;
  }

  ensure_packages('nfs-client', {
    name   => $::manila::params::nfs_client_package_name,
    ensure => $package_ensure,
  })
  Package<| title == 'nfs-client' |> { tag +> 'manila-support-package' }

  if $manage_storops {
    # Python library storops is required to run Unity driver.
    ensure_packages( 'storops', {
      ensure   => $package_ensure,
      provider => 'pip',
      tag      => 'manila-support-package',
    })
  }
}
