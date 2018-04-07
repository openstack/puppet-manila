# == Class: manila::volume::cinder
#
# Setup and configure Cinder communication
#
# === Parameters
#
# [*cinder_catalog_info*]
#   (optional) Info to match when looking for cinder in the service
#   catalog. Format is : separated values of the form:
#   <service_type>:<service_name>:<endpoint_type>
#   Defaults to 'volume:cinder:publicURL'
#
# [*cinder_ca_certificates_file*]
#   (optional) Location of ca certificates file to use for cinder
#   client requests.
#   Defaults to undef
#
# [*cinder_http_retries*]
#   (optional) Number of cinderclient retries on failed http calls.
#   Defaults to 3
#
# [*cinder_api_insecure*]
#   (optional) Allow to perform insecure SSL requests to cinder
#   Defaults to false
#
# [*cinder_cross_az_attach*]
#   (optional) Allow attach between instance and volume in different
#   availability zones.
#   Defaults to true
#
# [*cinder_admin_username*]
#   (optional) Cinder admin username.
#   Defaults to 'cinder'
#
# [*cinder_admin_password*]
#   (optional) Cinder admin password.
#   Defaults to undef
#
# [*cinder_admin_tenant_name*]
# (optional) Cinder admin tenant name
#   Defaults to 'service'
#
# [*cinder_admin_auth_url*]
# (optional) Identity service url
#   Defaults to 'http://localhost:5000/v2.0'
#
class manila::volume::cinder (
  $cinder_catalog_info         = 'volume:cinder:publicURL',
  $cinder_ca_certificates_file = undef,
  $cinder_http_retries         = 3,
  $cinder_api_insecure         = false,
  $cinder_cross_az_attach      = true,
  $cinder_admin_username       = 'cinder',
  $cinder_admin_password       = undef,
  $cinder_admin_tenant_name    = 'service',
  $cinder_admin_auth_url       = 'http://localhost:5000/v2.0',
) {

  include ::manila::deps

  manila_config {
    'DEFAULT/cinder_catalog_info':          value => $cinder_catalog_info;
    'DEFAULT/cinder_ca_certificates_file':  value => $cinder_ca_certificates_file;
    'DEFAULT/cinder_http_retries':          value => $cinder_http_retries;
    'DEFAULT/cinder_api_insecure':          value => $cinder_api_insecure;
    'DEFAULT/cinder_cross_az_attach':       value => $cinder_cross_az_attach;
    'DEFAULT/cinder_admin_username':        value => $cinder_admin_username;
    'DEFAULT/cinder_admin_password':        value => $cinder_admin_password, secret => true;
    'DEFAULT/cinder_admin_tenant_name':     value => $cinder_admin_tenant_name;
    'DEFAULT/cinder_admin_auth_url':        value => $cinder_admin_auth_url;
    }
}
