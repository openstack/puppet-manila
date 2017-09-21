# == Class: manila::keystone::auth
#
# Configures Manila user, service and endpoint in Keystone.
#
# === Parameters
#
# [*password*]
#   Password for Manila user. Required.
#
# [*email*]
#   Email for Manila user. Optional. Defaults to 'manila@localhost'.
#
# [*auth_name*]
#   Username for Manila service. Optional. Defaults to 'manila'.
#
# [*service_name*]
#   (optional) Name of the service.
#   Defaults to 'manila'.
#
# [*service_name_v2*]
#   (optional) Name of the service.
#   Defaults to 'manilav2'.
#
# [*configure_endpoint*]
# [*configure_endpoint*]
#   Should Manila endpoint be configured? Optional. Defaults to 'true'.
#   API v1 endpoint should be enabled in Icehouse for compatibility with Nova.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'share'.
#
# [*service_description*]
#    Description for keystone service. Optional. Defaults to 'Manila Service'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for Manila user. Optional. Defaults to 'services'.
#
# [*public_url*]
#   (optional) The endpoint's public url. (Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8786/v1/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*password_v2*]
#   Password for Manila v2 user. Optional. Defaults to undef.
#
# [*email_v2*]
#   Email for Manila v2 user. Optional. Defaults to 'manilav2@localhost'.
#
# [*auth_name_v2*]
#   Username for Manila v2 service. Optional. Defaults to 'manilav2'.
#
# [*configure_endpoint_v2*]
#   Should Manila v2 endpoint be configured? Optional. Defaults to 'true'.
#
# [*service_type_v2*]
#    Type of service v2. Optional. Defaults to 'sharev2'.
#
# [*service_description_v2*]
#    Description for keystone service v2. Optional. Defaults to 'Manila Service v2'.
#
# [*public_url_v2*]
#   (optional) The v2 endpoint's public url. (Defaults to 'http://127.0.0.1:8786/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*admin_url_v2*]
#   (optional) The endpoint's admin url. (Defaults to 'http://127.0.0.1:8786/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
#
# [*internal_url_v2*]
#   (optional) The endpoint's internal url. (Defaults to 'http://127.0.0.1:8786/v2/%(tenant_id)s')
#   This url should *not* contain any trailing '/'.
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
  $configure_endpoint     = true,
  $configure_endpoint_v2  = true,
  $service_type           = 'share',
  $service_type_v2        = 'sharev2',
  $service_description    = 'Manila Service',
  $service_description_v2 = 'Manila Service v2',
  $region                 = 'RegionOne',
  $public_url             = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $public_url_v2          = 'http://127.0.0.1:8786/v2/%(tenant_id)s',
  $admin_url              = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $admin_url_v2           = 'http://127.0.0.1:8786/v2/%(tenant_id)s',
  $internal_url           = 'http://127.0.0.1:8786/v1/%(tenant_id)s',
  $internal_url_v2        = 'http://127.0.0.1:8786/v2/%(tenant_id)s',
) {

  include ::manila::deps

  # for interface backward compatibility, we can't enforce to set a new parameter
  # so we take 'password' parameter by default but allow to override it.
  if ! $password_v2 {
    $password_v2_real = $password
  } else {
    $password_v2_real = $password_v2
  }

  Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'manila-api' |>
  Keystone_user_role["${auth_name_v2}@${tenant}"] ~> Service <| name == 'manila-api' |>

  keystone::resource::service_identity { 'manila':
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint,
    service_type        => $service_type,
    service_description => $service_description,
    auth_name           => $auth_name,
    service_name        => $service_name,
    region              => $region,
    password            => $password,
    email               => $email,
    tenant              => $tenant,
    public_url          => $public_url,
    admin_url           => $admin_url,
    internal_url        => $internal_url,
  }

  keystone::resource::service_identity { 'manilav2':
    configure_user      => true,
    configure_user_role => true,
    configure_endpoint  => $configure_endpoint_v2,
    service_type        => $service_type_v2,
    service_description => $service_description_v2,
    auth_name           => $auth_name_v2,
    service_name        => $service_name_v2,
    region              => $region,
    password            => $password_v2_real,
    email               => $email_v2,
    tenant              => $tenant,
    public_url          => $public_url_v2,
    admin_url           => $admin_url_v2,
    internal_url        => $internal_url_v2,
  }
}
