# == Class: manila::api
#
# Setup and configure the manila API endpoint
#
# === Parameters
#
# [*auth_strategy*]
#   (optional) Type of authentication to be used.
#   Defaults to 'keystone'
#
# [*os_region_name*]
#   (optional) Some operations require manila to make API requests
#   to Nova. This sets the keystone region to be used for these
#   requests. For example, boot-from-share.
#   Defaults to undef.
#
# [*package_ensure*]
#   (optional) The state of the package
#   Defaults to present
#
# [*bind_host*]
#   (optional) The manila api bind address
#   Defaults to 0.0.0.0
#
# [*default_share_type*]
#   (optional) Name of default share type which is used if user doesn't
#   set a share type explicitly when creating a share.
#   Defaults to $::os_service_default.
#
# [*enabled*]
#   (optional) The state of the service
#   Defaults to true
#
# [*sync_db*]
#   (optional) Run db sync on the node
#   Defaults to true
#
# [*manage_service*]
#   (optional) Whether to start/stop the service
#   Defaults to true
#
# [*ratelimits*]
#   (optional) The state of the service
#   Defaults to undef. If undefined the default ratelimiting values are used.
#
# [*ratelimits_factory*]
#   (optional) Factory to use for ratelimiting
#   Defaults to 'manila.api.v1.limits:RateLimitingMiddleware.factory'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $::os_service_default.
#
# [*enabled_share_protocols*]
#   (optional) Defines the enabled share protocols provided by Manila.
#   Defaults to $::os_service_default
#
# [*service_workers*]
#   (optional) Number of manila-api workers
#   Defaults to $::os_workers
#
# === DEPRECATED PARAMTERS
#
# [*service_port*]
#   (optional) DEPRECATED. The manila api port
#   Defaults to undef
#
class manila::api (
  $auth_strategy                = 'keystone',
  $os_region_name               = undef,
  $package_ensure               = 'present',
  $bind_host                    = '0.0.0.0',
  $default_share_type           = $::os_service_default,
  $enabled                      = true,
  $sync_db                      = true,
  $manage_service               = true,
  $ratelimits                   = undef,
  $ratelimits_factory           = 'manila.api.v1.limits:RateLimitingMiddleware.factory',
  $enable_proxy_headers_parsing = $::os_service_default,
  $enabled_share_protocols      = $::os_service_default,
  $service_workers              = $::os_workers,
  # Deprecated
  $service_port                 = undef,
) {

  include ::manila::deps
  include ::manila::params
  require ::keystone::python

  if $service_port {
    warning('service port is deprecated and will be removed in a future release')
  }

  Manila_config<||> ~> Service['manila-api']
  Manila_api_paste_ini<||> ~> Service['manila-api']

  if $::manila::params::api_package {
    Package['manila-api'] -> Service['manila-api']
    package { 'manila-api':
      ensure => $package_ensure,
      name   => $::manila::params::api_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  if $sync_db {
    include ::manila::db::sync
  }

  if $enabled {
    if $manage_service {
      $ensure = 'running'
    }
  } else {
    if $manage_service {
      $ensure = 'stopped'
    }
  }

  service { 'manila-api':
    ensure    => $ensure,
    name      => $::manila::params::api_service,
    enable    => $enabled,
    hasstatus => true,
    require   => Package['manila'],
    tag       => 'manila-service',
  }

  manila_config {
    'DEFAULT/osapi_share_listen':      value => $bind_host;
    'DEFAULT/enabled_share_protocols': value => $enabled_share_protocols;
    'DEFAULT/default_share_type':      value => $default_share_type;
    'DEFAULT/osapi_share_workers':     value => $service_workers;
  }

  oslo::middleware { 'manila_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
  }

  if $os_region_name {
    manila_config {
      'DEFAULT/os_region_name': value => $os_region_name;
    }
  }

  if $auth_strategy == 'keystone' {
    manila_config {
      'DEFAULT/auth_strategy': value => $auth_strategy;
    }
    include ::manila::keystone::authtoken

    if ($ratelimits != undef) {
      manila_api_paste_ini {
        'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
        'filter:ratelimit/limits':               value => $ratelimits;
      }
    }
  }

}
