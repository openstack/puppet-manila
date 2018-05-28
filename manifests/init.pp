# Class: manila
#
# == Parameters
#
# [*sql_connection*]
#    Url used to connect to database.
#    (Optional) Defaults to undef.
#
# [*sql_idle_timeout*]
#   Timeout when db connections should be reaped.
#   (Optional) Defaults to undef.
#
# [*database_retry_interval*]
#   (optional) Interval between retries of opening a database connection.
#   (Defaults to undef)
#
# [*database_min_pool_size*]
#   (optional) Minimum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_pool_size*]
#   (optional) Maximum number of SQL connections to keep open in a pool.
#   Defaults to undef.
#
# [*database_max_retries*]
#   Maximum db connection retries during startup.
#   Setting -1 implies an infinite retry count.
#   (Optional) Defaults to undef.
#
# [*database_max_overflow*]
#   (optional) If set, use this value for max_overflow with sqlalchemy.
#   Defaults to undef.
#
# [*state_path*]
#   (optional) Directory for storing state.
#   Defaults to '/var/lib/manila'
#
# [*default_transport_url*]
#    (optional) A URL representing the messaging driver to use and its full
#    configuration. Transport URLs take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#    Defaults to $::os_service_default
#
# [*rpc_response_timeout*]
#  (Optional) Seconds to wait for a response from a call.
#  Defaults to $::os_service_default
#
# [*control_exchange*]
#   (Optional) The default exchange under which topics are scope.
#   Defaults to 'openstack'.
#
# [*package_ensure*]
#    (Optional) Ensure state for package.
#    Defaults to 'present'
#
# [*notification_transport_url*]
#   (optional) A URL representing the messaging driver to use for
#   notifications and its full configuration. Transport URLs
#   take the form:
#      transport://user:pass@host1:port[,hostN:portN]/virtual_host
#   Defaults to $::os_service_default.
#
# [*notification_topics*]
#   (optional) AMQP topics to publish to when using the RPC notification driver.
#   (list value)
#   Default to $::os_service_default
#
# [*notification_driver*]
#   (optional) Driver or drivers to handle sending notifications.
#   Defaults to 'messaging'
#
# [*rabbit_ha_queues*]
#   (optional) Use HA queues in RabbitMQ (x-ha-policy: all).
#   Defaults to  $::os_service_default.
#
# [*rabbit_use_ssl*]
#   (Optional) Connect over SSL for RabbitMQ.
#   Defaults to $::os_service_default.
#
# [*kombu_ssl_ca_certs*]
#   (optional) SSL certification authority file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_certfile*]
#   (optional) SSL cert file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_keyfile*]
#   (optional) SSL key file (valid only if SSL enabled).
#   Defaults to $::os_service_default
#
# [*kombu_ssl_version*]
#   (optional) SSL version to use (valid only if SSL enabled).
#   Valid values are TLSv1, SSLv23 and SSLv3. SSLv2 may be
#   available on some distributions.
#   Defaults to $::os_service_default
#
# [*kombu_failover_strategy*]
#   (Optional) Determines how the next RabbitMQ node is chosen in case the one
#   we are currently connected to becomes unavailable. Takes effect only if
#   more than one RabbitMQ node is provided in config. (string value)
#   Defaults to $::os_service_default
#
# [*amqp_durable_queues*]
#   (optional) Use durable queues in amqp.
#   Defaults to $::os_service_default.
#
# [*use_stderr*]
#   (optional) Use stderr for logging
#   Defaults to undef
#
# [*use_syslog*]
#   Use syslog for logging.
#   (Optional) Defaults to false.
#
# [*log_facility*]
#   Syslog facility to receive log lines.
#   (Optional) Defaults to LOG_USER.
#
# [*log_dir*]
#   (optional) Directory where logs should be stored.
#   If set to $::os_service_default, it will not log to any directory.
#   Defaults to '/var/log/manila'
#
# [*use_ssl*]
#   (optional) Enable SSL on the API server
#   Defaults to false, not set
#
# [*cert_file*]
#   (optinal) Certificate file to use when starting API server securely
#   Defaults to false, not set
#
# [*key_file*]
#   (optional) Private key file to use when starting API server securely
#   Defaults to false, not set
#
# [*ca_file*]
#   (optional) CA certificate file to use to verify connecting clients
#   Defaults to false, not set_
#
# [*debug*]
#   (Optional) Should the daemons log debug messages
#   Defaults to false
#
# [*api_paste_config*]
#   (Optional) Allow Configuration of /etc/manila/api-paste.ini.
#
# [*storage_availability_zone*]
#   (optional) Availability zone of the node.
#   Defaults to 'nova'
#
# [*rootwrap_config*]
#   (optional) Path to the rootwrap configuration file to use for
#   running commands as root
#
# [*lock_path*]
#   (optional) Location to store Manila locks
#   Defaults to '/tmp/manila/manila_locks'
#
# [*amqp_server_request_prefix*]
#   address prefix used when sending to a specific server
#   Defaults to 'exclusive'
#
# [*amqp_broadcast_prefix*]
#   address prefix used when broadcasting to all servers
#   Defaults to 'broadcast'
#
# [*amqp_group_request_prefix*]
#   address prefix when sending to any server in group
#   Defaults to 'unicast'
#
# [*amqp_container_name*]
#   Name for the AMQP container
#   Defaults to guest
#
# [*amqp_idle_timeout*]
#   Timeout for inactive connections (in seconds)
#   Defaults to 0
#
# [*amqp_trace*]
#   Debug: dump AMQP frames to stdout
#   Defaults to false
#
# [*amqp_ssl_ca_file*]
#   (optional) CA certificate PEM file to verify server certificate
#   Defaults to $::os_service_default
#
# [*amqp_ssl_cert_file*]
#   (optional) Identifying certificate PEM file to present to clients
#   Defaults to $::os_service_default
#
# [*amqp_ssl_key_file*]
#   (optional) Private key PEM file used to sign cert_file certificate
#   Defaults to $::os_service_default
#
# [*amqp_ssl_key_password*]
#   (optional) Password for decrypting ssl_key_file (if encrypted)
#   Defaults to $::os_service_default
#
# [*amqp_allow_insecure_clients*]
#   (optional) Accept clients using either SSL or plain TCP
#   Defaults to false
#
# [*amqp_sasl_mechanisms*]
#   (Optional) Space separated list of acceptable SASL mechanisms
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_dir*]
#   (Optional) Path to directory that contains the SASL configuration
#   Defaults to $::os_service_default.
#
# [*amqp_sasl_config_name*]
#   (Optional) Name of configuration file (without .conf suffix)
#   Defaults to $::os_service_default.
#
# [*amqp_username*]
#   (Optional) User name for message broker authentication
#   Defaults to $::os_service_default.
#
# [*amqp_password*]
#   (Optional) Password for message broker authentication
#   Defaults to $::os_service_default.
#
# [*purge_config*]
#   (optional) Whether to set only the specified config options
#   in the manila config.
#   Defaults to false.
#
# [*host*]
#   (optional) Name of this node. This can be an opaque identifier. It is
#   not necessarily a host name, FQDN, or IP address.
#   Defaults to $::os_service_default
#
class manila (
  $sql_connection              = undef,
  $sql_idle_timeout            = undef,
  $database_max_retries        = undef,
  $database_retry_interval     = undef,
  $database_min_pool_size      = undef,
  $database_max_pool_size      = undef,
  $database_max_overflow       = undef,
  $default_transport_url       = $::os_service_default,
  $rpc_response_timeout        = $::os_service_default,
  $control_exchange            = 'openstack',
  $notification_transport_url  = $::os_service_default,
  $notification_driver         = 'messaging',
  $notification_topics         = $::os_service_default,
  $rabbit_ha_queues            = $::os_service_default,
  $rabbit_use_ssl              = $::os_service_default,
  $kombu_ssl_ca_certs          = $::os_service_default,
  $kombu_ssl_certfile          = $::os_service_default,
  $kombu_ssl_keyfile           = $::os_service_default,
  $kombu_ssl_version           = $::os_service_default,
  $kombu_failover_strategy     = $::os_service_default,
  $amqp_durable_queues         = $::os_service_default,
  $package_ensure              = 'present',
  $use_ssl                     = false,
  $ca_file                     = false,
  $cert_file                   = false,
  $key_file                    = false,
  $api_paste_config            = '/etc/manila/api-paste.ini',
  $use_stderr                  = undef,
  $use_syslog                  = undef,
  $log_facility                = undef,
  $log_dir                     = undef,
  $debug                       = undef,
  $storage_availability_zone   = 'nova',
  $rootwrap_config             = '/etc/manila/rootwrap.conf',
  $state_path                  = '/var/lib/manila',
  $lock_path                   = '/tmp/manila/manila_locks',
  $amqp_server_request_prefix  = 'exclusive',
  $amqp_broadcast_prefix       = 'broadcast',
  $amqp_group_request_prefix   = 'unicast',
  $amqp_container_name         = 'guest',
  $amqp_idle_timeout           = '0',
  $amqp_trace                  = false,
  $amqp_allow_insecure_clients = false,
  $amqp_ssl_ca_file            = $::os_service_default,
  $amqp_ssl_cert_file          = $::os_service_default,
  $amqp_ssl_key_file           = $::os_service_default,
  $amqp_ssl_key_password       = $::os_service_default,
  $amqp_sasl_mechanisms        = $::os_service_default,
  $amqp_sasl_config_dir        = $::os_service_default,
  $amqp_sasl_config_name       = $::os_service_default,
  $amqp_username               = $::os_service_default,
  $amqp_password               = $::os_service_default,
  $purge_config                = false,
  $host                        = $::os_service_default,
) {

  include ::manila::deps
  include ::manila::db
  include ::manila::logging
  include ::manila::params

  if $use_ssl {
    if !$cert_file {
      fail('The cert_file parameter is required when use_ssl is set to true')
    }
    if !$key_file {
      fail('The key_file parameter is required when use_ssl is set to true')
    }
  }

  package { 'manila':
    ensure  => $package_ensure,
    name    => $::manila::params::package_name,
    require => Anchor['manila::install::begin'],
    tag     => ['openstack', 'manila-package'],
  }

  resources { 'manila_config':
    purge => $purge_config,
  }

  oslo::messaging::rabbit { 'manila_config':
    rabbit_use_ssl          => $rabbit_use_ssl,
    amqp_durable_queues     => $amqp_durable_queues,
    rabbit_ha_queues        => $rabbit_ha_queues,
    kombu_ssl_ca_certs      => $kombu_ssl_ca_certs,
    kombu_ssl_certfile      => $kombu_ssl_certfile,
    kombu_ssl_keyfile       => $kombu_ssl_keyfile,
    kombu_ssl_version       => $kombu_ssl_version,
    kombu_failover_strategy => $kombu_failover_strategy,
  }

  oslo::messaging::amqp { 'manila_config':
    server_request_prefix  => $amqp_server_request_prefix,
    broadcast_prefix       => $amqp_broadcast_prefix,
    group_request_prefix   => $amqp_group_request_prefix,
    container_name         => $amqp_container_name,
    idle_timeout           => $amqp_idle_timeout,
    trace                  => $amqp_trace,
    allow_insecure_clients => $amqp_allow_insecure_clients,
    ssl_ca_file            => $amqp_ssl_ca_file,
    ssl_key_password       => $amqp_ssl_key_password,
    ssl_cert_file          => $amqp_ssl_cert_file,
    ssl_key_file           => $amqp_ssl_key_file,
    sasl_mechanisms        => $amqp_sasl_mechanisms,
    sasl_config_dir        => $amqp_sasl_config_dir,
    sasl_config_name       => $amqp_sasl_config_name,
    username               => $amqp_username,
    password               => $amqp_password,
  }

  oslo::messaging::default { 'manila_config':
    transport_url        => $default_transport_url,
    rpc_response_timeout => $rpc_response_timeout,
    control_exchange     => $control_exchange,
  }

  oslo::messaging::notifications { 'manila_config':
    transport_url => $notification_transport_url,
    driver        => $notification_driver,
    topics        => $notification_topics,
  }

  manila_config {
    'DEFAULT/api_paste_config':          value => $api_paste_config;
    'DEFAULT/storage_availability_zone': value => $storage_availability_zone;
    'DEFAULT/rootwrap_config':           value => $rootwrap_config;
    'DEFAULT/state_path':                value => $state_path;
    'DEFAULT/host':                      value => $host;
  }

  oslo::concurrency { 'manila_config': lock_path => $lock_path }

  # SSL Options
  if $use_ssl {
    manila_config {
      'DEFAULT/ssl_cert_file' : value => $cert_file;
      'DEFAULT/ssl_key_file' :  value => $key_file;
    }
    if $ca_file {
      manila_config { 'DEFAULT/ssl_ca_file' :
        value => $ca_file,
      }
    } else {
      manila_config { 'DEFAULT/ssl_ca_file' :
        ensure => absent,
      }
    }
  } else {
    manila_config {
      'DEFAULT/ssl_cert_file' : ensure => absent;
      'DEFAULT/ssl_key_file' :  ensure => absent;
      'DEFAULT/ssl_ca_file' :   ensure => absent;
    }
  }

}
