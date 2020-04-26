# == Class: manila::network::neutron
#
# Setup and configure Neutron communication
#
# === Parameters
#
# [*insecure*]
#   (optional) Verify HTTPS connections
#   Defaults to $::os_service_default
#
# [*auth_url*]
#   (optional) Authentication URL
#   Defaults to $::os_service_default
#
# [*auth_type*]
#   (optional) Authentication type to load
#   Defaults to $::os_service_default
#
# [*cafile*]
#   (optional) PEM encoded Certificate Authority to use when verifying HTTPS
#   connections.
#   Defaults to $::os_service_default
#
# [*user_domain_name*]
#   (optional) User's domain name
#   Defaults to 'Default'
#
# [*project_domain_name*]
#   (optional) Domain name containing project
#   Defaults to 'Default'
#
# [*project_name*]
#   (optional) Project name to scope to
#   Defaults to 'services'
#
# [*region_name*]
#   (optional) Region name for connecting to neutron
#   Defaults to $::os_service_default
#
# [*timeout*]
#   (optional) Timeout value for http requests
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (optional) The type of neutron endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username
#   Defaults to 'neutron'
#
# [*password*]
#   (optional) User's password
#   Defaults to undef
#
# [*network_plugin_ipv4_enabled*]
#   (optional) Whether to support Ipv4 network resource
#   Defaults to $::os_service_default
#
# [*network_plugin_ipv6_enabled*]
#   (optional) whether to support IPv6 network resource
#   Defaults to $::os_service_default
#
class manila::network::neutron (
  $insecure                     = $::os_service_default,
  $auth_url                     = $::os_service_default,
  $auth_type                    = $::os_service_default,
  $cafile                       = $::os_service_default,
  $user_domain_name             = 'Default',
  $project_domain_name          = 'Default',
  $project_name                 = 'services',
  $region_name                  = $::os_service_default,
  $timeout                      = $::os_service_default,
  $endpoint_type                = $::os_service_default,
  $username                     = 'neutron',
  $password                     = undef,
  $network_plugin_ipv4_enabled  = $::os_service_default,
  $network_plugin_ipv6_enabled  = $::os_service_default,
) {

  $neutron_plugin_name = 'manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin'

  manila_config {
    'DEFAULT/network_api_class':           value => $neutron_plugin_name;
    'neutron/insecure':                    value => $insecure;
    'neutron/auth_url':                    value => $auth_url;
    'neutron/auth_type':                   value => $auth_type;
    'neutron/cafile':                      value => $cafile;
    'neutron/region_name':                 value => $region_name;
    'neutron/timeout':                     value => $timeout;
    'neutron/endpoint_type':               value => $endpoint_type;
    'DEFAULT/network_plugin_ipv4_enabled': value => $network_plugin_ipv4_enabled;
    'DEFAULT/network_plugin_ipv6_enabled': value => $network_plugin_ipv6_enabled;
    }

  if $auth_type == 'password' {
    manila_config {
      'neutron/username':            value => $username;
      'neutron/user_domain_name':    value => $user_domain_name;
      'neutron/password':            value => $password, secret => true;
      'neutron/project_name':        value => $project_name;
      'neutron/project_domain_name': value => $project_domain_name;
    }
  }
}
