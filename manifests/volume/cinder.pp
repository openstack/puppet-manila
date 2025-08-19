# == Class: manila::volume::cinder
#
# Setup and configure Cinder communication
#
# === Parameters
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
#   Defaults to 'cinder'
#
# [*password*]
#   (optional) User's password
#   Defaults to $facts['os_service_default']
#
# [*http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Defaults to $facts['os_service_default']
#
# [*cross_az_attach*]
#   (optional) Allow attach between instance and volume in different
#   availability zones.
#   Defaults to $facts['os_service_default']
#
class manila::volume::cinder (
  $insecure                    = $facts['os_service_default'],
  $auth_url                    = $facts['os_service_default'],
  $auth_type                   = 'password',
  $cafile                      = $facts['os_service_default'],
  $user_domain_name            = 'Default',
  $project_domain_name         = 'Default',
  $project_name                = 'services',
  $system_scope                = $facts['os_service_default'],
  $region_name                 = $facts['os_service_default'],
  $endpoint_type               = $facts['os_service_default'],
  $username                    = 'cinder',
  $password                    = $facts['os_service_default'],
  $http_retries                = $facts['os_service_default'],
  $cross_az_attach             = $facts['os_service_default'],
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
    'cinder/insecure':            value => $insecure;
    'cinder/auth_url':            value => $auth_url;
    'cinder/auth_type':           value => $auth_type;
    'cinder/cafile':              value => $cafile;
    'cinder/region_name':         value => $region_name;
    'cinder/endpoint_type':       value => $endpoint_type;
    'cinder/username':            value => $username;
    'cinder/user_domain_name':    value => $user_domain_name;
    'cinder/password':            value => $password, secret => true;
    'cinder/project_name':        value => $project_name_real;
    'cinder/project_domain_name': value => $project_domain_name_real;
    'cinder/system_scope':        value => $system_scope;
    'cinder/http_retries':        value => $http_retries;
    'cinder/cross_az_attach':     value => $cross_az_attach;
  }
}
