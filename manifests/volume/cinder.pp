# == Class: manila::volume::cinder
#
# Setup and configure Cinder communication
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
#   (optional) Region name for connecting to cinder
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (optional) The type of cinder endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username
#   Defaults to 'cinder'
#
# [*password*]
#   (optional) User's password
#   Defaults to $::os_service_default
#
# [*http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Defaults to $::os_service_default
#
# [*cross_az_attach*]
#   (optional) Allow attach between instance and volume in different
#   availability zones.
#   Defaults to $::os_service_default
#
# === DEPRECATED PARAMETERS
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service
#   catalog. Format is : separated values of the form:
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to undef
#
# [*cinder_ca_certificates_file*]
#   (optional) Location of ca certificates file to use for cinder
#   client requests.
#   Defaults to undef
#
# [*cinder_http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Defaults to undef
#
# [*cinder_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to cinder
#   Defaults to undef
#
# [*cinder_cross_az_attach*]
#   (optional) Allow attach between instance and volume in different
#   availability zones.
#   Defaults to undef
#
# [*cinder_admin_username*]
#   (optional) Cinder admin username.
#   Defaults to undef
#
# [*cinder_admin_password*]
#   (optional) Cinder admin password.
#   Defaults to $::os_service_default
#
# [*cinder_admin_tenant_name*]
# (optional) Cinder admin tenant name
#   Defaults to undef
#
# [*cinder_admin_auth_url*]
# (optional) Identity service url
#   Defaults to undef
#
class manila::volume::cinder (
  $insecure                    = $::os_service_default,
  $auth_url                    = $::os_service_default,
  $auth_type                   = $::os_service_default,
  $cafile                      = $::os_service_default,
  $user_domain_name            = 'Default',
  $project_domain_name         = 'Default',
  $project_name                = 'services',
  $region_name                 = $::os_service_default,
  $endpoint_type               = $::os_service_default,
  $username                    = 'cinder',
  $password                    = $::os_service_default,
  $http_retries                = $::os_service_default,
  $cross_az_attach             = $::os_service_default,
  # DEPRECATED PARAMETERS
  $cinder_catalog_info         = undef,
  $cinder_ca_certificates_file = undef,
  $cinder_http_retries         = undef,
  $cinder_api_insecure         = undef,
  $cinder_cross_az_attach      = undef,
  $cinder_admin_username       = undef,
  $cinder_admin_password       = undef,
  $cinder_admin_tenant_name    = undef,
  $cinder_admin_auth_url       = undef,
) {

  include manila::deps

  if $cinder_catalog_info {
    warning('The cinder_catalog_info parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $cinder_api_insecure {
    warning('The cinder_api_insecure parameter is deprecated, use insecure instead.')
  }

  if $cinder_ca_certificates_file {
    warning('The cinder_ca_certificates_file parameter is deprecated, use cafile instead.')
  }

  if $cinder_admin_username {
    warning('The cinder_admin_username parameter is deprecated, use username instead.')
  }

  if $cinder_admin_password {
    warning('The cinder_admin_password parameter is deprecated, use password instead.')
  }

  if $cinder_admin_tenant_name {
    warning('The cinder_admin_tenant_name parameter is deprecated, use project_name instead.')
  }

  if $cinder_admin_auth_url {
    warning('The cinder_admin_auth_url parameter is deprecated, use auth_url instead.')
  }

  if $cinder_http_retries {
    warning('The cinder_http_retries parameter is deprecated, use http_retries instead')
  }

  if $cinder_cross_az_attach {
    warning('The cinder_cross_az_attach parameter is deprecated, use cross_az_attach instead')
  }

  $insecure_real = pick($cinder_api_insecure, $insecure)
  $cafile_real = pick($cinder_ca_certificates_file, $cafile)
  $username_real = pick($cinder_admin_username, $username)
  $password_real = pick_default($cinder_admin_password, $password)
  $project_name_real = pick($cinder_admin_tenant_name, $project_name)
  $auth_url_real = pick($cinder_admin_auth_url, $auth_url)
  $http_retries_real = pick($cinder_http_retries, $http_retries)
  $cross_az_attach_real = pick($cinder_cross_az_attach, $cross_az_attach)

  manila_config {
    'cinder/insecure':            value => $insecure_real;
    'cinder/auth_url':            value => $auth_url_real;
    'cinder/auth_type':           value => $auth_type;
    'cinder/cafile':              value => $cafile_real;
    'cinder/region_name':         value => $region_name;
    'cinder/endpoint_type':       value => $endpoint_type;
    'cinder/username':            value => $username_real;
    'cinder/user_domain_name':    value => $user_domain_name;
    'cinder/password':            value => $password_real, secret => true;
    'cinder/project_name':        value => $project_name_real;
    'cinder/project_domain_name': value => $project_domain_name;
    'cinder/http_retries':        value => $http_retries_real;
    'cinder/cross_az_attach':     value => $cross_az_attach_real;
  }
}
