# == Class: manila::compute::nova
#
# Setup and configure Nova communication
#
# === Parameters
#
# [*password*]
#   (required) User's password
#
# [*insecure*]
#   (optional) Verify HTTPS connections
#   Defaults to $facts['os_service_default']
#
# [*auth_url*]
#   (optional) Authentication URL
#   Defaults to 'http://127.0.0.1:5000'
#
# [*auth_type*]
#   (optional) Authentication type to load
#   Defaults to 'password'
#
# [*cafile*]
#   (optional) PEM encoded Certificate Authority to use when verifying HTTPS
#   connections.
#   Defaults to $facts['os_service_default']
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
# [*system_scope*]
#   (optional) Scope for system operations.
#   Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (optional) Region name for connecting to nova
#   Defaults to $facts['os_service_default']
#
# [*timeout*]
#   (optional) Timeout value for http requests
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (optional) The type of nova endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*username*]
#   (optional) Username
#   Defaults to 'nova'
#
# [*api_microversion*]
#   (optional) Version of Nova API to be used
#   Defaults to $facts['os_service_default']
#
class manila::compute::nova (
  $password,
  $insecure            = $facts['os_service_default'],
  $auth_url            = 'http://127.0.0.1:5000',
  $auth_type           = 'password',
  $cafile              = $facts['os_service_default'],
  $user_domain_name    = 'Default',
  $project_domain_name = 'Default',
  $project_name        = 'services',
  $system_scope        = $facts['os_service_default'],
  $region_name         = $facts['os_service_default'],
  $timeout             = $facts['os_service_default'],
  $endpoint_type       = $facts['os_service_default'],
  $username            = 'nova',
  $api_microversion    = $facts['os_service_default'],
) {
  include manila::deps

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  manila_config {
    'nova/insecure':            value => $insecure;
    'nova/auth_url':            value => $auth_url;
    'nova/auth_type':           value => $auth_type;
    'nova/cafile':              value => $cafile;
    'nova/region_name':         value => $region_name;
    'nova/timeout':             value => $timeout;
    'nova/endpoint_type':       value => $endpoint_type;
    'nova/username':            value => $username;
    'nova/user_domain_name':    value => $user_domain_name;
    'nova/password':            value => $password, secret => true;
    'nova/project_name':        value => $project_name_real;
    'nova/project_domain_name': value => $project_domain_name_real;
    'nova/system_scope':        value => $system_scope;
    'nova/api_microversion':    value => $api_microversion;
  }
}
