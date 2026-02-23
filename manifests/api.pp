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
#   Defaults to $facts['os_service_default'].
#
# [*enabled*]
#   (optional) The state of the service
#   Defaults to true
#
# [*sync_db*]
#   (optional) Run db sync on the node
#   Defaults to true
#
# [*service_name*]
#   (optional) Name of the service that will be providing the
#   server functionality of manila-api.
#   If the value is 'httpd', this means manila-api will be a web
#   service, and you must use another class to configure that
#   web service. For example, use class { 'manila::wsgi::apache'...}
#   to make manila-api be a web app using apache mod_wsgi.
#   Defaults to '$manila::params::api_service'
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
#   Defaults to 'manila.api.v2.limits:RateLimitingMiddleware.factory'
#
# [*enable_proxy_headers_parsing*]
#   (Optional) Enable paste middleware to handle SSL requests through
#   HTTPProxyToWSGI middleware.
#   Defaults to $facts['os_service_default'].
#
# [*max_request_body_size*]
#   (Optional) Set max request body size
#   Defaults to $facts['os_service_default'].
#
# [*enabled_share_protocols*]
#   (optional) Defines the enabled share protocols provided by Manila.
#   Defaults to $facts['os_service_default']
#
# [*service_workers*]
#   (optional) Number of manila-api workers
#   Defaults to $facts['os_workers']
#
# [*admin_only_metadata*]
#   (optional) Metadata keys that should only be manipulated by administrators.
#   Defaults to $facts['os_service_default'].
#
class manila::api (
  $auth_strategy                          = 'keystone',
  Stdlib::Ensure::Package $package_ensure = 'present',
  $bind_host                              = '0.0.0.0',
  $default_share_type                     = $facts['os_service_default'],
  Boolean $enabled                        = true,
  Boolean $sync_db                        = true,
  Boolean $manage_service                 = true,
  String[1] $service_name                 = $manila::params::api_service,
  $ratelimits                             = undef,
  $ratelimits_factory                     = 'manila.api.v2.limits:RateLimitingMiddleware.factory',
  $enable_proxy_headers_parsing           = $facts['os_service_default'],
  $max_request_body_size                  = $facts['os_service_default'],
  $enabled_share_protocols                = $facts['os_service_default'],
  $service_workers                        = $facts['os_workers'],
  $admin_only_metadata                    = $facts['os_service_default'],
) inherits manila::params {
  include manila::deps
  include manila::params
  include manila::policy

  if $manila::params::api_package {
    package { 'manila-api':
      ensure => $package_ensure,
      name   => $manila::params::api_package,
      tag    => ['openstack', 'manila-package'],
    }
  }

  if $sync_db {
    include manila::db::sync
  }

  if $manage_service {
    case $service_name {
      'httpd': {
        Service <| title == 'httpd' |> { tag +> 'manila-service' }

        # We need to make sure manila-api/eventlet is stopped before trying to
        # start apache
        service { 'manila-api':
          ensure => 'stopped',
          name   => $manila::params::api_service,
          enable => false,
          tag    => ['manila-service'],
        }

        Service['manila-api'] -> Service['httpd']

        # On any api-paste.ini config change, we must restart Manila API.
        Manila_api_paste_ini<||> ~> Service['httpd']
      }
      default: {
        $service_ensure = $enabled ? {
          true    => 'running',
          default => 'stopped',
        }

        service { 'manila-api':
          ensure    => $service_ensure,
          name      => $service_name,
          enable    => $enabled,
          hasstatus => true,
          tag       => 'manila-service',
        }

        # On any api-paste.ini config change, we must restart Manila API.
        Manila_api_paste_ini<||> ~> Service['manila-api']
        # On any uwsgi config change, we must restart Manila API.
        Manila_api_uwsgi_config<||> ~> Service['manila-api']
      }
    }
  }

  manila_config {
    'DEFAULT/osapi_share_listen':      value => $bind_host;
    'DEFAULT/enabled_share_protocols': value => join(any2array($enabled_share_protocols), ',');
    'DEFAULT/default_share_type':      value => $default_share_type;
    'DEFAULT/osapi_share_workers':     value => $service_workers;
    'DEFAULT/admin_only_metadata':     value => join(any2array($admin_only_metadata), ',');
  }

  oslo::middleware { 'manila_config':
    enable_proxy_headers_parsing => $enable_proxy_headers_parsing,
    max_request_body_size        => $max_request_body_size,
  }

  manila_config {
    'DEFAULT/auth_strategy': value => $auth_strategy;
  }
  if $auth_strategy == 'keystone' {
    include manila::keystone::authtoken
  }

  if $ratelimits != undef {
    manila_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': value => $ratelimits_factory;
      'filter:ratelimit/limits':               value => $ratelimits;
    }
  } else {
    manila_api_paste_ini {
      'filter:ratelimit/paste.filter_factory': ensure => absent;
      'filter:ratelimit/limits':               ensure => absent;
    }
  }
}
