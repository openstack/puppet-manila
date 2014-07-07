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
# [*auth_name_v2*]
#   Username for Manila v2 service. Optional. Defaults to 'manila2'.
#
# [*configure_endpoint*]
#   Should Manila endpoint be configured? Optional. Defaults to 'true'.
#   API v1 endpoint should be enabled in Icehouse for compatibility with Nova.
#
# [*configure_endpoint_v2*]
#   Should Manila v2 endpoint be configured? Optional. Defaults to 'true'.
#
# [*service_type*]
#    Type of service. Optional. Defaults to 'share'.
#
# [*service_type_v2*]
#    Type of API v2 service. Optional. Defaults to 'share2'.
#
# [*public_address*]
#    Public address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*admin_address*]
#    Admin address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*internal_address*]
#    Internal address for endpoint. Optional. Defaults to '127.0.0.1'.
#
# [*port*]
#    Port for endpoint. Optional. Defaults to '8776'.
#
# [*share_version*]
#    Manila API version. Optional. Defaults to 'v1'.
#
# [*region*]
#    Region for endpoint. Optional. Defaults to 'RegionOne'.
#
# [*tenant*]
#    Tenant for Manila user. Optional. Defaults to 'services'.
#
# [*public_protocol*]
#    Protocol for public endpoint. Optional. Defaults to 'http'.
#
# [*internal_protocol*]
#    Protocol for internal endpoint. Optional. Defaults to 'http'.
#
# [*admin_protocol*]
#    Protocol for admin endpoint. Optional. Defaults to 'http'.
#
class manila::keystone::auth (
  $password,
  $auth_name             = 'manila',
  $auth_name_v2          = 'manilav2',
  $email                 = 'manila@localhost',
  $tenant                = 'services',
  $configure_endpoint    = true,
  $configure_endpoint_v2 = true,
  $service_type          = 'share',
  $service_type_v2       = 'sharev2',
  $public_address        = '127.0.0.1',
  $admin_address         = '127.0.0.1',
  $internal_address      = '127.0.0.1',
  $port                  = '8776',
  $share_version         = 'v1',
  $region                = 'RegionOne',
  $public_protocol       = 'http',
  $admin_protocol        = 'http',
  $internal_protocol     = 'http'
) {

  Keystone_user_role["${auth_name}@${tenant}"] ~> Service <| name == 'manila-api' |>

  keystone_user { $auth_name:
    ensure   => present,
    password => $password,
    email    => $email,
    tenant   => $tenant,
  }
  keystone_user_role { "${auth_name}@${tenant}":
    ensure  => present,
    roles   => 'admin',
  }
  keystone_service { $auth_name:
    ensure      => present,
    type        => $service_type,
    description => 'Manila Service',
  }
  keystone_service { $auth_name_v2:
    ensure      => present,
    type        => $service_type_v2,
    description => 'Manila Service v2',
  }

  if $configure_endpoint {
    keystone_endpoint { "${region}/${auth_name}":
      ensure       => present,
      public_url   => "${public_protocol}://${public_address}:${port}/${share_version}/%(tenant_id)s",
      admin_url    => "${admin_protocol}://${admin_address}:${port}/${share_version}/%(tenant_id)s",
      internal_url => "${internal_protocol}://${internal_address}:${port}/${share_version}/%(tenant_id)s",
    }
  }
  if $configure_endpoint_v2 {
    keystone_endpoint { "${region}/${auth_name_v2}":
      ensure       => present,
      public_url   => "${public_protocol}://${public_address}:${port}/v2/%(tenant_id)s",
      admin_url    => "http://${admin_address}:${port}/v2/%(tenant_id)s",
      internal_url => "http://${internal_address}:${port}/v2/%(tenant_id)s",
    }
  }
}
