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
#   Defaults to 'service'
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
# === DEPRECATED PARAMETERS
#
# [*neutron_api_insecure*]
#   (optional) if set, ignore any SSL validation issues
#   Defaults to undef
#
# [*neutron_ca_certificates_file*]
#   (optional) Location of ca certificates file to use for
#   neutron client requests.
#   Defaults to undef
#
# [*neutron_url*]
#   (optional) URL for connecting to neutron
#   Defaults to undef
#
# [*neutron_url_timeout*]
#   (optional) timeout value for connecting to neutron in seconds
#   Defaults to undef
#
# [*neutron_admin_username*]
#   (optional) username for connecting to neutron in admin context
#   Defaults to undef
#
# [*neutron_admin_password*]
#   (optional) password for connecting to neutron in admin context
#   Defaults to undef
#
# [*neutron_admin_tenant_name*]
#   (optional) Tenant name for connecting to neutron in admin context
#   Defaults to undef
#
# [*neutron_region_name*]
#   (optional) region name for connecting to neutron in admin context
#   Defaults to undef
#
# [*neutron_admin_auth_url*]
#   (optional) auth url for connecting to neutron in admin context
#   Defaults to undef
#
# [*neutron_auth_strategy*]
#   (optional) auth strategy for connecting to
#   neutron in admin context.
#   Defaults to undef
#
class manila::network::neutron (
  $insecure                     = $::os_service_default,
  $auth_url                     = $::os_service_default,
  $auth_type                    = $::os_service_default,
  $cafile                       = $::os_service_default,
  $user_domain_name             = 'Default',
  $project_domain_name          = 'Default',
  $project_name                 = 'service',
  $region_name                  = $::os_service_default,
  $timeout                      = $::os_service_default,
  $endpoint_type                = $::os_service_default,
  $username                     = 'neutron',
  $password                     = undef,
  $network_plugin_ipv4_enabled  = $::os_service_default,
  $network_plugin_ipv6_enabled  = $::os_service_default,
  # DEPRECATED PARAMETERS
  $neutron_api_insecure         = undef,
  $neutron_ca_certificates_file = undef,
  $neutron_url                  = undef,
  $neutron_url_timeout          = undef,
  $neutron_admin_username       = undef,
  $neutron_admin_password       = undef,
  $neutron_admin_tenant_name    = undef,
  $neutron_region_name          = undef,
  $neutron_admin_auth_url       = undef,
  $neutron_auth_strategy        = undef,
) {

  if $neutron_api_insecure {
    warning('The neutron_api_insecure parameter is deprecated, use insecure instead.')
  }

  if $neutron_ca_certificates_file {
    warning('The neutron_ca_certificates_file parameter is deprecated, use cafile instead.')
  }

  if $neutron_url {
    warning('The neutron_url parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $neutron_url_timeout {
    warning('The neutron_url_timeout parameter is deprecated, use timeout instead.')
  }

  if $neutron_admin_username {
    warning('The neutron_admin_username parameter is deprecated, use username instead.')
  }

  if $neutron_admin_password {
    warning('The neutron_admin_password parameter is deprecated, use password instead.')
  }

  if $neutron_admin_tenant_name {
    warning('The neutron_admin_tenant_name parameter is deprecated, use project_name instead.')
  }

  if $neutron_region_name {
    warning('The neutron_region_name parameter is deprecated, use region_name instead.')
  }

  if $neutron_admin_auth_url {
    warning('The neutron_admin_auth_url parameter is deprecated, use auth_url instead.')
  }

  if $neutron_auth_strategy {
    warning('The neutron_url parameter is deprecated, has no effect and will be removed in a future release.')
  }

  $insecure_real = pick($neutron_api_insecure, $insecure)
  $auth_url_real = pick($neutron_admin_auth_url, $auth_url)
  $cafile_real = pick($neutron_ca_certificates_file, $cafile)
  $project_name_real = pick($neutron_admin_tenant_name, $project_name)
  $region_name_real = pick($neutron_region_name, $region_name)
  $timeout_real = pick($neutron_url_timeout, $timeout)
  $username_real = pick($neutron_admin_username, $username)
  $password_real = pick_default($neutron_admin_password, $password)

  $neutron_plugin_name = 'manila.network.neutron.neutron_network_plugin.NeutronNetworkPlugin'

  manila_config {
    'DEFAULT/network_api_class':           value => $neutron_plugin_name;
    'neutron/insecure':                    value => $insecure_real;
    'neutron/auth_url':                    value => $auth_url_real;
    'neutron/auth_type':                   value => $auth_type;
    'neutron/cafile':                      value => $cafile_real;
    'neutron/region_name':                 value => $region_name_real;
    'neutron/timeout':                     value => $timeout_real;
    'neutron/endpoint_type':               value => $endpoint_type;
    'DEFAULT/network_plugin_ipv4_enabled': value => $network_plugin_ipv4_enabled;
    'DEFAULT/network_plugin_ipv6_enabled': value => $network_plugin_ipv6_enabled;
    }

  if $auth_type == 'password' {
    manila_config {
      'neutron/username':            value => $username_real;
      'neutron/user_domain_name':    value => $user_domain_name;
      'neutron/password':            value => $password_real, secret => true;
      'neutron/project_name':        value => $project_name_real;
      'neutron/project_domain_name': value => $project_domain_name;
    }
  }
}
