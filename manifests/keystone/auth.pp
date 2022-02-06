# == Class: manila::keystone::auth
#
# Configures Manila user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   (Required) Password for Manila user.
#
# [*email*]
#   (Optional) Email for Manila user.
#   Defaults to 'manila@localhost'.
#
# [*auth_name*]
#   (Optional) Username for Manila service.
#   Defaults to 'manila'.
#
# [*service_name*]
#   (Optional) Name of the service.
#   Defaults to 'manila'.
#
# [*service_name_v2*]
#   (Optional) Name of the service.
#   Defaults to 'manilav2'.
#
# [*configure_endpoint*]
#   Should Manila endpoint be configured? Optional.
#   API v1 endpoint should be enabled in Icehouse for compatibility with Nova.
#   Defaults to true
#
# [*configure_user*]
#   (Optional) Should the service user be configured?
#   Defaults to true
#
# [*configure_user_role*]
#   (Optional) Should the admin role be configured for the service user?
#   Defaults to true
#
# [*service_type*]
#   (Optional) Type of service.
#   Defaults to 'share'.
#
# [*service_description*]
#   (Optional) Description for keystone service.
#   Defaults to 'Manila Service'.
#
# [*region*]
#   (Optional) Region for endpoint.
#   Defaults to 'RegionOne'.
#
# [*tenant*]
#   (Optional) Tenant for Manila user.
#   Defaults to 'services'.
#
# [*roles*]
#   (Optional) List of roles assigned to Manila user.
#   Defaults to ['admin']
#
# [*system_scope*]
#   (Optional) Scope for system operations.
#   Defaults to 'all'
#
# [*system_roles*]
#   (Optional) List of system roles assigned to Manila user.
#   Defaults to []
#
# [*public_url*]
#   (0ptional) The endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s'
#
# [*admin_url*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s'
#
# [*internal_url*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s'
#
# [*password_v2*]
#   (Optional) Password for Manila v2 user.
#   Defaults to undef.
#
# [*email_v2*]
#   (Optional) Email for Manila v2 user.
#   Defaults to 'manilav2@localhost'.
#
# [*auth_name_v2*]
#   (Optional) Username for Manila v2 service.
#   Defaults to 'manilav2'.
#
# [*configure_endpoint_v2*]
#   (Optional) Should Manila v2 endpoint be configured?
#   Defaults to true.
#
# [*configure_user_v2*]
#   (Optional) Should the v2 service user be configured?
#   Defaults to true
#
# [*configure_user_role_v2*]
#   (Optional) Should the admin role be configured for the v2 service user?
#   Defaults to true
#
# [*service_type_v2*]
#   (Optional) Type of service v2. Optional.
#   Defaults to 'sharev2'.
#
# [*service_description_v2*]
#   (Optional) Description for keystone service v2.
#   Defaults to 'Manila Service v2'.
#
# [*public_url_v2*]
#   (Optional) The v2 endpoint's public url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v2'
#
# [*admin_url_v2*]
#   (Optional) The endpoint's admin url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v2'
#
# [*internal_url_v2*]
#   (Optional) The endpoint's internal url.
#   This url should *not* contain any trailing '/'.
#   Defaults to 'http://127.0.0.1:8786/v2'
#
# === Examples
#
#  class { 'manila::keystone::auth':
#    public_url   => 'https://10.0.0.10:8786/v1/%(tenant_id)s',
#    internal_url => 'https://10.0.0.11:8786/v1/%(tenant_id)s',
#    admin_url    => 'https://10.0.0.11:8786/v1/%(tenant_id)s',
#  }
#
class manila::keystone::auth (
  $password,
  $password_v2            = undef,
  $auth_name_v2           = 'manilav2',
  $auth_name              = 'manila',
  $service_name           = 'manila',
  $service_name_v2        = 'manilav2',
  $email                  = 'manila@localhost',
  $email_v2               = 'manilav2@localhost',
  $tenant                 = 'services',
  $roles                  = ['admin'],
  $system_scope           = 'all',
  $system_roles           = [],
  $configure_endpoint     = true,
  $configure_endpoint_v2  = true,
  $configure_user         = true,
  $configure_user_v2      = true,
  $configure_user_role    = true,
  $configure_user_role_v2 = true,
  $service_type           = 'share',
  $service_type_v2        = 'sharev2',
  $service_description    = 'Manila Service',
  $service_description_v2 = 'Manila Service v2',
  $region                 = 'RegionOne',
  $public_url             = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $public_url_v2          = 'http://127.0.0.1:8786/v2',
  $admin_url              = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $admin_url_v2           = 'http://127.0.0.1:8786/v2',
  $internal_url           = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $internal_url_v2        = 'http://127.0.0.1:8786/v2',
) {

  include manila::deps

  Keystone::Resource::Service_identity['manila'] -> Anchor['manila::service::end']
  Keystone::Resource::Service_identity['manilav2'] -> Anchor['manila::service::end']

  # for interface backward compatibility, we can't enforce to set a new parameter
  # so we take 'password' parameter by default but allow to override it.
  if ! $password_v2 {
    $password_v2_real = $password
  } else {
    $password_v2_real = $password_v2
  }

  keystone::resource::service_identity { 'manila':
    configure_user      => $configure_user,
    configure_user_role => $configure_user_role,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    auth_name           => $auth_name,
    service_name        => $service_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

  keystone::resource::service_identity { 'manilav2':
    configure_user      => $configure_user_v2,
    configure_user_role => $configure_user_role_v2,
    configure_endpoint  => $configure_endpoint_v2,
    service_type        => $service_type_v2,
    service_description => $service_description_v2,
    auth_name           => $auth_name_v2,
    service_name        => $service_name_v2,
    region              => $region,
    password            => $password_v2_real,
    email               => $email_v2,
    tenant              => $tenant,
    roles               => $roles,
    system_scope        => $system_scope,
    system_roles        => $system_roles,
    public_url          => $public_url_v2,
    admin_url           => $admin_url_v2,
    internal_url        => $internal_url_v2,
  }
}
