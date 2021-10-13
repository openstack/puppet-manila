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
#   Defaults to 'password'
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
#   Defaults to $::os_service_default
#
# [*api_microversion*]
#   (optional) Version of Nova API to be used
#   Defaults to $::os_service_default
#
class manila::compute::nova (
  $insecure                  = $::os_service_default,
  $auth_url                  = $::os_service_default,
  $auth_type                 = 'password',
  $cafile                    = $::os_service_default,
  $user_domain_name          = 'Default',
  $project_domain_name       = 'Default',
  $project_name              = 'services',
  $region_name               = $::os_service_default,
  $endpoint_type             = $::os_service_default,
  $username                  = 'nova',
  $password                  = $::os_service_default,
  $api_microversion          = $::os_service_default,
) {

  include manila::deps

  manila_config {
    'nova/insecure':            value => $insecure;
    'nova/auth_url':            value => $auth_url;
    'nova/auth_type':           value => $auth_type;
    'nova/cafile':              value => $cafile;
    'nova/region_name':         value => $region_name;
    'nova/endpoint_type':       value => $endpoint_type;
    'nova/username':            value => $username;
    'nova/user_domain_name':    value => $user_domain_name;
    'nova/password':            value => $password, secret => true;
    'nova/project_name':        value => $project_name;
    'nova/project_domain_name': value => $project_domain_name;
    'nova/api_microversion':    value => $api_microversion;
  }
}
