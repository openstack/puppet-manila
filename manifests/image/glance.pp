# == Class: manila::image::glance
#
# Setup and configure Glance communication
#
# === Parameters
#
# [*api_microversion*]
#   (optional) Version of Glance API to be used
#   Defaults to $facts['os_service_default']
#
# [*insecure*]
#   (optional) Verify HTTPS connections
#   Defaults to $facts['os_service_default']
#
# [*auth_url*]
#   (optional) Authentication URL
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#   (optional) Authentication type to load
#   Defaults to 'password'
#
# [*cafile*]
#   (optional) Path to PEM encoded Certificate Authority to use when verifying
#   HTTPS connections.
#   Defaults to $facts['os_service_default']
#
# [*certfile*]
#   (optional) Path to PEM encoded client certificate cert file.
#   Defaults to $facts['os_service_default']
#
# [*keyfile*]
#   (optional) Path to PEM encoded client certificate key file.
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
#   (optional) Region name for connecting to cinder
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (optional) The type of cinder endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*username*]
#   (optional) Username
#   Defaults to 'glance'
#
# [*password*]
#   (optional) User's password
#   Defaults to $facts['os_service_default'],
#
class manila::image::glance (
  $api_microversion            = $facts['os_service_default'],
  $insecure                    = $facts['os_service_default'],
  $auth_url                    = $facts['os_service_default'],
  $auth_type                   = 'password',
  $cafile                      = $facts['os_service_default'],
  $certfile                    = $facts['os_service_default'],
  $keyfile                     = $facts['os_service_default'],
  $user_domain_name            = 'Default',
  $project_domain_name         = 'Default',
  $project_name                = 'services',
  $system_scope                = $facts['os_service_default'],
  $region_name                 = $facts['os_service_default'],
  $endpoint_type               = $facts['os_service_default'],
  $username                    = 'glance',
  $password                    = $facts['os_service_default'],
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
    'glance/api_microversion':    value => $api_microversion;
    'glance/insecure':            value => $insecure;
    'glance/auth_url':            value => $auth_url;
    'glance/auth_type':           value => $auth_type;
    'glance/cafile':              value => $cafile;
    'glance/certfile':            value => $certfile;
    'glance/keyfile':             value => $keyfile;
    'glance/user_domain_name':    value => $user_domain_name;
    'glance/project_domain_name': value => $project_domain_name_real;
    'glance/project_name':        value => $project_name_real;
    'glance/system_scope':        value => $system_scope;
    'glance/region_name':         value => $region_name;
    'glance/endpoint_type':       value => $endpoint_type;
    'glance/username':            value => $username;
    'glance/password':            value => $password, secret => true;
  }
}
