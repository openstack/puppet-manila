# == Class: manila::key_manager::barbican
#
# Setup and configure Barbican Key Manager options
#
# === Parameters
#
# [*password*]
#  (Required) Password to create for the service user
#
# [*barbican_endpoint*]
#   (Optional) Use this endpoint to connect to Barbican.
#   Defaults to $facts['os_service_default']
#
# [*barbican_api_version*]
#   (Optional) Version of the Barbican API.
#   Defaults to $facts['os_service_default']
#
# [*auth_endpoint*]
#   (Optional) Use this endpoint to connect to Keystone.
#   Defaults to $facts['os_service_default']
#
# [*barbican_endpoint_type*]
#   (Optional) Specifies the type of endpoint.
#   Defaults to $facts['os_service_default']
#
# [*barbican_region_name*]
#   (Optional) Specifies the region of the chosen endpoint.
#   Defaults to $facts['os_service_default']
#
# [*send_service_user_token*]
#   (Optional) The service uses service token feature when this is set as true.
#   Defaults to $facts['os_service_default']
#
# [*insecure*]
#   (Optional) If true, explicitly allow TLS without checking server cert
#   against any certificate authorities.  WARNING: not recommended.  Use with
#   caution.
#   Defaults to $facts['os_service_default']
#
# [*cafile*]
#   (Optional) A PEM encoded Certificate Authority to use when verifying HTTPs
#   connections.
#   Defaults to $facts['os_service_default'].
#
# [*certfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $facts['os_service_default'].
#
# [*keyfile*]
#   (Optional) Required if identity server requires client certificate
#   Defaults to $facts['os_service_default'].
#
# [*timeout*]
#   (Optional) Timeout value for connecting to barbican in seconds.
#   Defaults to $facts['os_service_default']
#
# [*auth_url*]
#  (Optional) The URL to use for authentication.
#  Defaults to 'http://localhost:5000'
#
# [*username*]
#  (Optional) The name of the service user
#  Defaults to 'manila'
#
# [*project_name*]
#  (Optional) Service project name
#  Defaults to 'services'
#
# [*user_domain_name*]
#  (Optional) Name of domain for $username
#  Defaults to 'Default'
#
# [*project_domain_name*]
#  (Optional) Name of domain for $project_name
#  Defaults to 'Default'
#
# [*system_scope*]
#  (Optional) Scope for system operations.
#  Defaults to $facts['os_service_default']
#
# [*region_name*]
#   (optional) Region name for connecting to keystone
#   Defaults to $facts['os_service_default']
#
# [*endpoint_type*]
#   (optional) The type of keystone endpoint to use when
#   looking up in the keystone catalog.
#   Defaults to $facts['os_service_default']
#
# [*auth_type*]
#  (Optional) Authentication type to load
#  Defaults to 'password'
#
class manila::key_manager::barbican (
  $password,
  $barbican_endpoint       = $facts['os_service_default'],
  $barbican_api_version    = $facts['os_service_default'],
  $auth_endpoint           = $facts['os_service_default'],
  $barbican_endpoint_type  = $facts['os_service_default'],
  $barbican_region_name    = $facts['os_service_default'],
  $send_service_user_token = $facts['os_service_default'],
  $insecure                = $facts['os_service_default'],
  $cafile                  = $facts['os_service_default'],
  $certfile                = $facts['os_service_default'],
  $keyfile                 = $facts['os_service_default'],
  $timeout                 = $facts['os_service_default'],
  $auth_url                = 'http://localhost:5000',
  $username                = 'manila',
  $project_name            = 'services',
  $user_domain_name        = 'Default',
  $project_domain_name     = 'Default',
  $system_scope            = $facts['os_service_default'],
  $region_name             = $facts['os_service_default'],
  $endpoint_type           = $facts['os_service_default'],
  $auth_type               = 'password',
) {
  include manila::deps

  oslo::key_manager::barbican { 'manila_config':
    barbican_endpoint       => $barbican_endpoint,
    barbican_api_version    => $barbican_api_version,
    auth_endpoint           => $auth_endpoint,
    barbican_endpoint_type  => $barbican_endpoint_type,
    barbican_region_name    => $barbican_region_name,
    send_service_user_token => $send_service_user_token,
    insecure                => $insecure,
    cafile                  => $cafile,
    certfile                => $certfile,
    keyfile                 => $keyfile,
    timeout                 => $timeout,
  }

  if is_service_default($system_scope) {
    $project_name_real = $project_name
    $project_domain_name_real = $project_domain_name
  } else {
    $project_name_real = $facts['os_service_default']
    $project_domain_name_real = $facts['os_service_default']
  }

  manila_config {
    'barbican/auth_url':            value => $auth_url;
    'barbican/username':            value => $username;
    'barbican/user_domain_name':    value => $user_domain_name;
    'barbican/password':            value => $password, secret => true;
    'barbican/project_name':        value => $project_name_real;
    'barbican/project_domain_name': value => $project_domain_name_real;
    'barbican/system_scope':        value => $system_scope;
    'barbican/region_name':         value => $region_name;
    'barbican/endpoint_type':       value => $endpoint_type;
    'barbican/auth_type':           value => $auth_type;
  }
}
