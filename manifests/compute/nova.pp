# == Class: manila::compute::nova
#
# Setup and configure Nova communication
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
#   (optional) Region name for connecting to nova
#   Defaults to $::os_service_default
#
# [*endpoint_type*]
#   (optional) The type of nova endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $::os_service_default
#
# [*username*]
#   (optional) Username
#   Defaults to 'nova'
#
# [*password*]
#   (optional) User's password
#   Only required if auth_type has been set to "password"
#   Defaults to undef
#
# === DEPRECATED PARAMETERS
#
# [*nova_catalog_info*]
#   (optional) Info to match when looking for nova in the service
#   catalog. Format is: separated values of the form
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to undef
#
# [*nova_catalog_admin_info*]
#   (optional) Same as nova_catalog_info, but for admin endpoint
#   Defaults to undef
#
# [*nova_api_insecure*]
#   Allow to perform insecure SSL requests to nova
#   Defaults to undef
#
# [*nova_ca_certificates_file*]
#   (optional) Location of CA certificates file to use for nova client requests
#   (string value)
#   Defaults to undef
#
# [*nova_admin_username*]
#   (optional) Nova admin username
#   Defaults to undef
#
# [*nova_admin_password*]
#   (optional) Nova admin password
#   Defaults to undef
#
# [*nova_admin_tenant_name*]
#   (optional) Nova admin tenant name
#   Defaults to undef
#
# [*nova_admin_auth_url*]
#  (optional) Identity service url
#   Defaults to undef
#
class manila::compute::nova (
  $insecure                  = $::os_service_default,
  $auth_url                  = $::os_service_default,
  $auth_type                 = $::os_service_default,
  $cafile                    = $::os_service_default,
  $user_domain_name          = 'Default',
  $project_domain_name       = 'Default',
  $project_name              = 'services',
  $region_name               = $::os_service_default,
  $endpoint_type             = $::os_service_default,
  $username                  = 'nova',
  $password                  = undef,
  # DEPRECATED PARAMETERS
  $nova_catalog_info         = undef,
  $nova_catalog_admin_info   = undef,
  $nova_api_insecure         = undef,
  $nova_ca_certificates_file = undef,
  $nova_admin_username       = undef,
  $nova_admin_password       = undef,
  $nova_admin_tenant_name    = undef,
  $nova_admin_auth_url       = undef,
) {

  include manila::deps

  if $nova_catalog_info {
    warning('The nova_catalog_info parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $nova_catalog_admin_info {
    warning('The nova_catalog_admin_info parameter is deprecated, has no effect and will be removed in a future release.')
  }

  if $nova_api_insecure {
    warning('The nova_api_insecure parameter is deprecated, use insecure instead.')
  }

  if $nova_ca_certificates_file {
    warning('The nova_ca_certificates_file parameter is deprecated, use cafile instead.')
  }

  if $nova_admin_username {
    warning('The nova_admin_username parameter is deprecated, use username instead.')
  }

  if $nova_admin_password {
    warning('The nova_admin_password parameter is deprecated, use password instead.')
  }

  if $nova_admin_tenant_name {
    warning('The nova_admin_tenant_name parameter is deprecated, use project_name instead.')
  }

  if $nova_admin_auth_url {
    warning('The nova_admin_auth_url parameter is deprecated, use auth_url instead.')
  }

  $insecure_real = pick($nova_api_insecure, $insecure)
  $cafile_real = pick($nova_ca_certificates_file, $cafile)
  $username_real = pick($nova_admin_username, $username)
  $password_real = pick_default($nova_admin_password, $password)
  $project_name_real = pick($nova_admin_tenant_name, $project_name)
  $auth_url_real = pick($nova_admin_auth_url, $auth_url)

  manila_config {
    'nova/insecure':      value => $insecure_real;
    'nova/auth_url':      value => $auth_url_real;
    'nova/auth_type':     value => $auth_type;
    'nova/cafile':        value => $cafile_real;
    'nova/region_name':   value => $region_name;
    'nova/endpoint_type': value => $endpoint_type;
    }

  if $auth_type == 'password' {
    manila_config {
      'nova/username':            value => $username_real;
      'nova/user_domain_name':    value => $user_domain_name;
      'nova/password':            value => $password_real, secret => true;
      'nova/project_name':        value => $project_name_real;
      'nova/project_domain_name': value => $project_domain_name;
    }
  }
}
